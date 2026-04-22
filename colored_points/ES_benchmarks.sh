#!/bin/bash

# ==============================================================================
# Benchmarking Script for clingo, clingo-lpx, and SAT solvers via ES_color.py
# (c) Vitalii Koshelev, koshelev@mccme.ru
#
# MODES OF OPERATION:
# 1. Clingo Mode (Default): Runs clingo on the logic model (.lp file).
#    Tests both (n-1) SAT and (n) UNSAT cases.
#    Usage: ./test_ai5.sh 43
#
# 2. SAT Solver Mode: Runs a specified SAT solver (minisat, cadical, etc.).
#    Supports passing arbitrary solver flags (e.g., -v, --model).
#    Tests both (n-1) SAT and (n) UNSAT cases.
#    Usage: ./test_ai5.sh 43 minisat -v
#
# 3. SMT2 Mode: Triggered by 'xgrid=X'. Runs ONLY (n-1) using Z3 in SMT2 mode.
#    The generator ES_color.py produces SMT2 output when 'xgrid' is passed.
#    This mode is optimized for heavy SAT cases with linear constraints.
#    Usage: ./test_ai5.sh 43 xgrid=1
#
# 4. LPX Mode: Triggered by 'lpxgrid=X'. Runs ONLY (n-1) using clingo-lpx.
#    Appends the 'lpx' file and passes 'xgrid=X' to clingo-lpx solver.
#    Usage: ./test_ai5.sh 43 lpxgrid=1
# ==============================================================================

# --- Initialize Global Timing (MUST BE AT THE TOP) ---
GLOBAL_START=$(date +%s)

# --- Configuration: Paths to binaries ---
CLINGO_BIN="clingo ES_color.lp --heuristic=Domain --sat-p=3"
GEN_PY="./ES_color.py"
LOG_DIR="./logs_$(date +%Y%m%d_%H%M%S)"

# --- Global Variables for Summary Report ---
TOTAL_CPU_TIME=0
TEST_COUNT=0
ACTUAL_SOLVER_USED="clingo" # Default placeholder

# --- Function: Parse SAT/UNSAT Status ---
# Uses strict line matching for clingo to avoid false positives from statistics.
# Uses prefix matching for DIMACS/SMT2 solvers (z3, minisat, cadical).
parse_status() {
    local out="$1"
    # Clingo specific: Match exact status lines
    if echo "$out" | grep -qxFi "UNSATISFIABLE"; then echo "UNSAT"; return; fi
    if echo "$out" | grep -qxFi "SATISFIABLE"; then echo "SAT"; return; fi

    # DIMACS/SMT2 specific: Match standard prefixes (e.g., 's UNSAT' or 'unsat')
    if echo "$out" | grep -qiE "(^s UNSAT|^unsat)"; then
        echo "UNSAT"
    elif echo "$out" | grep -qiE "(^s SAT|^sat)"; then
        echo "SAT"
    else
        echo "UNKNOWN"
    fi
}

# --- Function: Run Single Test Case ---
run_test() {
    local base_args="$1"
    local n_val="$2"
    local solver="$3"
    local flags="$4"

    # Extract special mode parameters (xgrid=X or lpxgrid=X)
    local all_params="$solver $flags"
    local xgrid_val=$(echo "$all_params" | grep -oP 'xgrid=\K\d+')
    local lpx_val=$(echo "$all_params" | grep -oP 'lpxgrid=\K\d+')

    # Target selection:
    # Normal modes test (n-1) and (n).
    # Special modes (xgrid/lpxgrid) only test (n-1) as it's the target for linear constraints.
    local targets=($((n_val-1)) $n_val)
    if [[ ! -z "$xgrid_val" || ! -z "$lpx_val" ]]; then
        targets=($((n_val-1)))
    fi

    for current_n in "${targets[@]}"; do
        local full_args="$base_args -c n=$current_n"
        local cmd_to_exec=""

        # Readable Log Naming: "-c nc1=1 -c tr2=0" -> "nc1_1_tr2_0"
        local pretty_args=$(echo "$base_args" | sed 's/-c //g' | tr '=' '_' | tr -s ' ' | sed 's/ /_/g')
        local log_name="test_n${current_n}_${pretty_args}.log"

        # Determine the execution command based on detected mode
        if [[ ! -z "$lpx_val" ]]; then
            ACTUAL_SOLVER_USED="clingo-lpx"
            cmd_to_exec="clingo-lpx lpx ES_color.lp --sat-p=3,size=0 --configuration=$CONF$full_args -c xgrid=$lpx_val"
        elif [[ ! -z "$xgrid_val" ]]; then
            ACTUAL_SOLVER_USED="z3 (SMT2)"
            cmd_to_exec="$GEN_PY $full_args xgrid=$xgrid_val | z3 -in"
        else
            ACTUAL_SOLVER_USED="$solver"
            if [[ "$solver" == "clingo" || -z "$solver" ]]; then
                cmd_to_exec="$CLINGO_BIN --configuration=$CONF$full_args"
            else
                cmd_to_exec="$GEN_PY$full_args | $solver $flags"
            fi
        fi

        printf "%-125s" "$cmd_to_exec"
        mkdir -p "$LOG_DIR"

        # Measure CPU Time (User + System) using /usr/bin/time
        # Accurate even under high system load.
        local total_out
        total_out=$(/usr/bin/time -f "|||%U %S" bash -c "$cmd_to_exec" 2>&1)

        # Save raw solver output
        echo "$total_out" > "$LOG_DIR/${log_name}"

        # Parse results and update statistics
        local status=$(parse_status "$total_out")
        local timing=$(echo "$total_out" | grep -a "|||" | tail -n 1 | sed 's/|||//')
        local cpu_time=$(echo "$timing" | awk '{printf "%.3f", $1 + $2}')

        TOTAL_CPU_TIME=$(echo "$TOTAL_CPU_TIME + $cpu_time" | bc -l)
        ((TEST_COUNT++))

        printf " | %-7s %-8ss\n" "$status" "$cpu_time"
    done
}

# --- Function: Process predefined data groups ---
process_data() {
    local var=($1); shift
    local data=("$@")
    local num_vars=${#var[@]}
    local step=$((num_vars + 1))
    if ((step > 3)); then CONF="crafty"; else CONF="frumpy"; fi

    for ((i=0; i<${#data[@]}; i+=step)); do
        local n=${data[i+step-1]}
        local cmd_args=""
        for ((j=0; j<num_vars; j++)); do
            cmd_args+=" -c ${var[j]}=${data[i+j]}"
        done
        run_test "$cmd_args" "$n" "$SELECTED_SOLVER" "$SOLVER_PARAMS"
    done
}

# --- Arguments Handling Logic ---
CASE_ID=$1
if [[ "$2" == xgrid=* || "$2" == lpxgrid=* ]]; then
    SELECTED_SOLVER="clingo"
    SOLVER_PARAMS="$2"
else
    SELECTED_SOLVER=${2:-"clingo"}
    shift 2 2>/dev/null
    SOLVER_PARAMS="$*"
fi

# --- Logic Switch for Test Cases ---
case $CASE_ID in
    44)    process_data "cv1 cv2" 4 4 9   3 4 11   2 4 11   1 4 13   0 4 17   3 3 11   2 3 12   1 3 15   0 3 21   2 2 12   1 2 16   1 1 18;;  # 0 2 25
    43)    process_data "cv1 tr2" 2 4 7   1 4 9    0 4 11   2 3 8    1 3 9    0 3 12   2 2 8    1 2 9    0 2 13   2 1 9    1 1 11   0 1 14   2 0 11   1 0 14;; # 0 0 26
    -44)   process_data "nc1 nc2" 3 3 7   2 3 9    1 3 9    0 3 12   2 2 9    1 2 10   0 2 14   1 1 11   0 1 15;;  # 0 0 26
    -43)   process_data "nc1 tr2" 2 3 6   2 2 7    2 1 7    2 0 9    1 3 8    1 2 8    1 1 8    1 0 11   0 3 9    0 2 10   0 1 10   0 0 14;;
    i44)   process_data "is1 is2" 3 3 7   2 3 9    1 3 9    0 3 13   2 2 9    1 2 11   0 2 16   1 1 13   0 1 22;;
    i43)   process_data "is1 tr2" 2 3 6   1 3 8    0 3 9    2 2 7    1 2 8    0 2 11   2 1 7    1 1 9    0 1 11   2 0 10   1 0 12   0 0 17;;
    332)   process_data "pr1 tr1 tr2" 0 0 4 9    0 3 3 6    0 2 3 7    0 1 3 7    0 0 3 10   0 2 2 7    0 1 2 8    0 0 2 10   0 1 1 8   0 0 1 11   0 0 0 14;;
    333)   process_data "tr1 tr2 tr3" 4 4 4 7    3 3 3 8    2 2 2 10   1 1 1 13   0 6 6 11   0 4 4 12   0 3 3 13   0 2 2 15 \
                                      0 1 7 14   0 1 4 15   0 1 3 16   0 1 2 17   0 1 1 19   0 0 8 19   0 0 5 20;; # 0 0 4 21   0 0 3 23   0 0 2 26   0 0 0 inf
    -444)  process_data "nc1 nc2 nc3" 6 6 6 10   5 5 5 12   4 4 4 14   3 3 3 16;;
    i444)  process_data "is1 is2 is3" 6 6 6 10   5 5 5 12   4 4 4 16   3 3 3 19;;  # 2 2 2 inf?
    3333)  process_data "tr1 tr2 tr3 tr4" 6 6 6 6 9   5 5 5 5 10   4 4 4 4 12   3 3 3 3 13   2 2 2 2 18;;  # 0 0 0 0 inf
    33333) process_data "tr1 tr2 tr3 tr4 tr5" 8 8 8 8 8 11   7 7 7 7 7 12   6 6 6 6 6 14   5 5 5 5 5 16   4 4 4 4 4 18;;  # 1 1 1 1 1 inf
esac


# --- Summary Report Generation ---
GLOBAL_END=$(date +%s)
WALL_CLOCK_TIME=$((GLOBAL_END - GLOBAL_START))

echo "----------------------------------------------------------------------------------------------------"
echo "SUMMARY FOR $ACTUAL_SOLVER_USED (Case $CASE_ID):"
echo "Tests executed: $TEST_COUNT"
echo "Total CPU Time: $TOTAL_CPU_TIME seconds"
echo "Wall Clock Time: $WALL_CLOCK_TIME seconds"
echo "Logs saved in:  $LOG_DIR"
echo "----------------------------------------------------------------------------------------------------"
