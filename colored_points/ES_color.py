#!/usr/bin/env python3
from itertools import combinations
import sys

# 1. Parse parameters
raw_params = []
n = 0
sb_enabled = True
output_smt2 = False
xgrid_val = 0

for arg in sys.argv[1:]:
    if '=' in arg:
        k, v = arg.split('=')
        if k == 'n': n = int(v)
        elif k == 'sb' and v == 'off': sb_enabled = False
        elif k == 'xgrid':
            output_smt2 = True
            xgrid_val = int(v)
            sb_enabled = False
        else:
            raw_params.append((k[:2], int(v)))

if n == 0 or not raw_params:
    sys.exit("Usage: ./ES_color.py tr1=0 tr2=0 n=9")

N = range(n)
num_colors = len(raw_params)
all_limits = [v for k, v in raw_params]
all_limits += [v+1 for k, v in raw_params if k == 'is']
Q = range(max(all_limits) + 1) if all_limits else range(1)

num_vars = n * num_colors
constraints = []

l = {}
ext = {}
tr = {}

def add_cons(L1, L2):
    # This logic is sacred: it produces exactly 1 or 2 clauses
    constraints.append(L1 + L2)
    if L2 != []:
        constraints.append(L1 + [-x for x in L2])

# 2. X coordinates calculation (0-based) for SMT
mid = n // 2
is_even = (n % 2 == 0)

if xgrid_val == 1:
    x_coords = {i: i for i in range(n)}
else:
    x_coords = {
        i: (-(xgrid_val**(mid - i - 1)) if i < mid else
            (xgrid_val**(i - mid - (0 if is_even else 1)) if i > mid or is_even else 0))
        for i in range(n)
    }

# 3. Point-Color Assignments (One-Hot)
for i in N:
    point_vars = [i + 1 + (c * n) for c in range(num_colors)]
    constraints.append([-v for v in point_vars])
    if num_colors > 1:
        for v1, v2 in combinations(point_vars, 2):
            constraints.append([v1, v2])

# 4. Orientation variables
for (a,b,c) in combinations(N, 3):
    num_vars += 1
    l[(a,b,c)] = num_vars

# Geometric axioms
for (a,b,c,d) in combinations(N, 4):
    add_cons([], [l[(a,b,c)], -l[(a,c,d)], l[(b,c,d)]])
    add_cons([], [l[(a,b,c)], -l[(a,b,d)], l[(a,c,d)]])
    add_cons([], [l[(a,b,c)], -l[(a,b,d)], l[(b,c,d)]])
    add_cons([], [l[(a,b,d)], -l[(a,c,d)], l[(b,c,d)]])

# External point logic
for (a,b,c,d) in combinations(N, 4):
    num_vars += 1
    ext[(a,b,d,c)] = num_vars
    add_cons([-ext[(a,b,d,c)]], [l[(b,c,d)], l[(a,c,d)]])
    num_vars += 1
    ext[(a,c,d,b)] = num_vars
    add_cons([-ext[(a,c,d,b)]], [l[(a,b,c)], l[(a,b,d)]])

# 5. Density variables (tr)
for (a,b,c) in combinations(N, 3):
    for q in Q:
        num_vars += 1
        tr[(a,b,c,q)] = num_vars
        PT = [pt for pt in range(a + 1, c) if pt != b]
        if len(PT) < q:
            add_cons([-tr[(a,b,c,q)]], [])
        else:
            for X in combinations(PT, len(PT) - q):
                add_cons([-tr[(a,b,c,q)]] + [ext[(a,b,c,x)] for x in X], [])

# 6. Color-specific constraints
for c_idx, (c_type, limit) in enumerate(raw_params):
    off = c_idx * n
    if c_type == 'pr':
        for i, j in combinations(N, 2):
            constraints.append([i + 1 + off, j + 1 + off])

    elif c_type == 'tr':
        for (a,b,c) in combinations(N, 3):
            p_vars = [x + 1 + off for x in [a,b,c]]
            add_cons(p_vars + [tr[(a,b,c,limit)]], [])

    elif c_type in ['cv', 'nc', 'is']:
        is_is = (c_type == 'is')
        is_nc = (c_type == 'nc')
        for (a,b,c,d) in combinations(N, 4):
            p_vars = [x + 1 + off for x in [a,b,c,d]]
            for q1 in range(limit + 1):
                q2 = limit - q1
                add_cons(p_vars + [tr[(a,b,c,q1)], tr[(a,c,d,q2)]], [l[(a,b,c)], l[(b,c,d)]])
                add_cons(p_vars + [tr[(a,b,c,q1)], tr[(b,c,d,q2)]], [l[(a,b,d)], -l[(a,c,d)]])

                if is_nc:
                    add_cons(p_vars + [tr[(a,b,c,q1)], tr[(a,b,d,q2)]], [l[(a,b,d)], -l[(a,b,c)]])
                    add_cons(p_vars + [tr[(a,b,d,q1)], tr[(b,c,d,q2)]], [l[(a,b,d)], -l[(a,b,c)]])
                    add_cons(p_vars + [tr[(a,b,c,q1)], tr[(b,c,d,q2)]], [l[(a,b,d)], -l[(a,b,c)]])
                    add_cons(p_vars + [tr[(a,b,c,q1)], tr[(a,c,d,q2)]], [l[(a,c,d)], -l[(b,c,d)]])
                    add_cons(p_vars + [tr[(a,b,c,q1)], tr[(b,c,d,q2)]], [l[(a,c,d)], -l[(b,c,d)]])
                    add_cons(p_vars + [tr[(a,c,d,q1)], tr[(b,c,d,q2)]], [l[(a,c,d)], -l[(b,c,d)]])

                if is_is:
                    add_cons(p_vars + [tr[(a,c,d,limit+1)]], [l[(a,b,d)], -l[(a,b,c)]])
                    add_cons(p_vars + [tr[(a,b,d,limit+1)]], [l[(a,c,d)], -l[(b,c,d)]])

# 7. Symmetry breaking
if sb_enabled:
    for (a,b,c) in combinations(N, 3):
        if a == 0:
            add_cons([l[(a,b,c)]], [])

# 8. Final Output (DIMACS or SMT2)
if not output_smt2:
    print(f"p cnf {num_vars} {len(constraints)}")
    for c in constraints:
        sys.stdout.write(" ".join(map(str, c)) + " 0\n")
else:
    # Variables and Constants declarations
    for i in range(1, num_vars + 1): print(f"(declare-fun k{i} () Bool)")
    for i in range(n):
        print(f"(define-fun x{i} () Int {x_coords[i]})")
        print(f"(declare-fun y{i} () Int)")

    # Arithmetic-Orientation coupling
    if xgrid_val > 0:
        for (a,b,c), k_id in l.items():
            ka, kb, kc = x_coords[c] - x_coords[b], x_coords[a] - x_coords[c], x_coords[b] - x_coords[a]
            sum_expr = f"(+ (* {ka} y{a}) (* {kb} y{b}) (* {kc} y{c}))"
            print(f"(assert (= k{k_id} (>= {sum_expr} 1)))")
            print(f"(assert (or k{k_id} (<= {sum_expr} -1)))")

    # Boolean Clauses
    for c in constraints:
        lits = [f"k{v}" if v > 0 else f"(not k{-v})" for v in c]
        print(f"(assert (or {' '.join(lits)}))")

    print("(check-sat)")
    #print("(set-option :produce-models true)")
    #print("(check-sat-using (then simplify propagate-values solve-eqs bit-blast sat))")
    # Tailored get-value output: one line per point for easy piping
    for i in range(n):
        # We collect: x_i, y_i and all color variables for this specific point
        # Point i Color 1 is k_{i+1}, Color 2 is k_{i+1+n}, etc.
        cvars = " ".join([f"k{i + 1 + (c * n)}" for c in range(num_colors)])
        print(f"(get-value (x{i} y{i} {cvars}))")
