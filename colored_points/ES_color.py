#!/usr/bin/env python3
from itertools import combinations, permutations
import sys
import random

# 1. Parse parameters
raw_params = []
n = 0
sb_enabled = True
output_smt2 = False
xgrid_val = -1

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

l = {}
ext = {}
tr = {}

num_vars = 0

def new_var(num = 1):
    global num_vars
    for i in range(num):
        num_vars += 1
        if output_smt2:
            print(f"(declare-fun k{num_vars} () Bool)")
    return num_vars

def add_cons(L1, L2):
    # Generates 1 or 2 clauses based on conditional geometric constraints
    clause(L1 + L2)
    if L2:
        clause(L1 + [-x for x in L2])

def clause(L):
    # Prints a single SAT clause for SMT2 or appends it to constraints
    if output_smt2:
        lits = [f"k{v}" if v > 0 else f"(not k{-v})" for v in L]
        print(f"(assert (or {' '.join(lits)}))")
    else:
        constraints.append(L)

num_vars = new_var(n * num_colors)
constraints = []


# 2. X coordinates calculation (0-based) for SMT
mid = n // 2
is_even = (n % 2 == 0)

if xgrid_val == 0:
    # Intentional non-determinism for parallel instances scaling.
    # Avoid adding random.seed() here to let workers explore different search spaces.
    s_v = sorted(random.sample(range(n * 10), n))
    x_coords = {i: val for i, val in enumerate(s_v)}
elif xgrid_val == 1:
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
    add_cons([-v for v in point_vars], [])
    if num_colors > 1:
        for v1, v2 in combinations(point_vars, 2):
            add_cons([v1, v2], [])

# 4. Orientation variables
for (a,b,c) in combinations(N, 3):
    l[(a,b,c)] = new_var()

# Geometric axioms
for (a,b,c,d) in combinations(N, 4):
    add_cons([], [l[(a,b,c)], -l[(a,c,d)], l[(b,c,d)]])
    add_cons([], [l[(a,b,c)], -l[(a,b,d)], l[(a,c,d)]])
    add_cons([], [l[(a,b,c)], -l[(a,b,d)], l[(b,c,d)]])
    add_cons([], [l[(a,b,d)], -l[(a,c,d)], l[(b,c,d)]])

# External point logic
for (a,b,c,d) in combinations(N, 4):
    ext[(a,b,d,c)] = new_var()
    add_cons([-ext[(a,b,d,c)]], [l[(b,c,d)], l[(a,c,d)]])
    ext[(a,c,d,b)] = new_var()
    add_cons([-ext[(a,c,d,b)]], [l[(a,b,c)], l[(a,b,d)]])

# 5. Density variables (tr)
for (a,b,c) in combinations(N, 3):
    for q in Q:
        tr[(a,b,c,q)] = new_var()
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

    elif c_type in ['rp', 'sp']:
        # 6.1. Alias permutation indices for orientation and density
        # This maps all arbitrary permutations to canonical ordered keys.
        # Required only for pentagons to maintain O(1) dictionary lookups.
        for (a, b, c) in combinations(N, 3):
            l[(b,c,a)] = l[(c,a,b)] = l[(a,b,c)]
            l[(a,c,b)] = l[(b,a,c)] = l[(c,b,a)] = -l[(a,b,c)]
            for q in Q:
                tr[(a,c,b,q)] = tr[(b,a,c,q)] = tr[(b,c,a,q)] = tr[(c,a,b,q)] = tr[(c,b,a,q)] = tr[(a,b,c,q)]

        # 6.2. Non-convex pentagon constraints generation
        for (a, b, c, d, e) in permutations(N, 5):
            p_vars = [x + 1 + off for x in [a,b,c,d,e]]
            for i1 in range(limit + 1):
                for i2 in range(limit - i1 + 1):
                    i3 = limit - i1 - i2
                    # Relaxed mode: fast filtering but allows some self-intersecting shapes (where abc and cde intersect)
                    if c_type == 'rp':
                        add_cons(p_vars + [tr[(a,b,c,i1)], tr[(b,c,d,i2)], tr[(c,d,e,i3)], l[(a,b,c)], -l[(b,c,d)], l[(c,d,e)]], [])
                    # Strict mode: structurally strict clauses to guarantee geometric soundness (abc and cde must not intersect)
                    if c_type == 'sp':
                        add_cons(p_vars + [tr[(a,b,c,i1)], tr[(b,c,d,i2)], tr[(c,d,e,i3)], l[(a,b,c)], -l[(b,c,d)], l[(c,d,e)], -l[(a,c,d)]], [])
                        add_cons(p_vars + [tr[(a,b,c,i1)], tr[(b,c,d,i2)], tr[(c,d,e,i3)], l[(a,b,c)], -l[(b,c,d)], l[(c,d,e)], -l[(b,c,e)]], [])
                        add_cons(p_vars + [tr[(a,b,c,i1)], tr[(b,c,d,i2)], tr[(c,d,e,i3)], l[(a,b,c)], -l[(b,c,d)], l[(c,d,e)], l[(a,c,d)], l[(b,c,e)], l[(a,c,e)]], [])


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
    for i in range(n):
        print(f"(define-fun x{i} () Int {x_coords[i]})")
        print(f"(declare-fun y{i} () Int)")

    # Arithmetic-Orientation coupling
    if xgrid_val >= 0:
        for (a,b,c) in combinations(N, 3):
            ka, kb, kc = x_coords[c] - x_coords[b], x_coords[a] - x_coords[c], x_coords[b] - x_coords[a]
            sum_expr = f"(+ (* {ka} y{a}) (* {kb} y{b}) (* {kc} y{c}))"
            print(f"(assert (= k{l[(a,b,c)]} (>= {sum_expr} 1)))")
            print(f"(assert (or k{l[(a,b,c)]} (<= {sum_expr} -1)))")

    print("(check-sat)")
    #print("(set-option :produce-models true)")
    #print("(check-sat-using (then simplify propagate-values solve-eqs bit-blast sat))")
    # Tailored get-value output: one line per point for easy piping
    for i in range(n):
        # We collect: x_i, y_i and all color variables for this specific point
        # Point i Color 1 is k_{i+1}, Color 2 is k_{i+1+n}, etc.
        cvars = " ".join([f"k{i + 1 + (c * n)}" for c in range(num_colors)])
        print(f"(get-value (x{i} y{i} {cvars}))")
