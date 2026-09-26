# Everywhere Unbalanced Points: An ASP Approach

This repository contains an alternative combinatorial verification of the *Everywhere Unbalanced Points* problem using *Answer Set Programming (ASP)* via `clingo`.

### Scope and Context
This project operates purely at the level of **rank-3 chirotopes (monotone signotopes)**, assuming the points are ordered by their x-coordinate. It evaluates the combinatorial existence of these configurations. **This encoding does not handle geometric realizability (finding explicit Cartesian coordinates).**

Through this combinatorial lens, the model independently verifies the results presented in [1]: it confirms the absence of solutions for odd n < 21 (and even n < 12), yields a definitive *UNSAT* for 19 points, and successfully finds a *SAT* signotope configuration for 21 points.

---

## Computational Benchmarks

All instances were executed using `clingo` with the following solver heuristics:
```bash
clingo imba.lp --configuration=frumpy --sat-p=3 -V3 -s -c imba=2 -c n=[N]
```

### Execution Logs and Timings (`imba=2`)

| File Name | Points (n) | Status | CPU Time (seconds) | Human-readable Time |
| :--- | :--- | :--- | :--- | :--- |
| `imba.lp.2.10.log` | 10 | **UNSAT** | 0.056s | Immediate |
| `imba.lp.2.12.log` | 12 | **SAT** | 0.219s | Immediate |
| `imba.lp.2.13.log` | 13 | **UNSAT** | 1.030s | ~1 second |
| `imba.lp.2.15.log` | 15 | **UNSAT** | 27.696s | ~28 seconds |
| `imba.lp.2.17.log` | 17 | **UNSAT** | 4,486.808s | ~1.2 hours |
| `imba.lp.2.19.log` | 19 | **UNSAT** | 991,627.297s | ~11.4 days |
| `imba.lp.2.21.log` | 21 | **SAT** | 17,509.897s | ~4.8 hours |

*Hardware Spec: Intel(R) Xeon(R) Gold 6226R CPU @ 2.90GHz*

---

## Key Domain-Specific Optimizations

To help the underlying CDCL engine prune the search space effectively during the grounding and solving phases, the ASP model incorporates explicit geometric propagation rules:

1. **Transitivity of Collinearity:** If triplets of points dynamically force a straight-line constraint, the collinearity is propagated transitively across the configuration.
2. **Sign Consistency:** Enforces geometric consistency of point orientations and signs relative to collinear lines, significantly cutting down dead-end branches in the search tree before hitting the heavy `#sum` aggregate constraints.

---

## References
[1] B. Subercaseaux, E. Mackey, L. Qian, M. J. H. Heule, *Automated Symmetric Constructions in Discrete Geometry*. arXiv preprint [arXiv:2506.00224](https://arxiv.org/pdf/2506.00224).
[2] **Authors' Code Reference:** [bsubercaseaux/automatic-symmetries](https://github.com/bsubercaseaux/automatic-symmetries)
