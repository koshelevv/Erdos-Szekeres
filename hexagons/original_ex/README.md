# Original Experimental Results: ~h_ex(6, Q)

This directory contains the original source code and execution logs used to obtain the results for Erdos--Szekeres-type problem for hexagons with exact number of interior points from Q \subset \mathbb{N}, 0 \in Q --  ~h_ex(6, Q)

## Contents
- `ES_hexagons_2params.lp`: The exact ASP script used for the computation of ~h_ex(6, Q). 
  (Note: The filename reflects the working title used during development).
   Experiments:
clingo ES_hexagons_2params.lp --configuration=frumpy -V3 -s --sat-prepro=3,size=0 -c n=17 -c q1=1 -c q2=2 > hexagons.Q_012.17pt.log
clingo ES_hexagons_2params.lp --configuration=frumpy -V3 -s --sat-prepro=3,size=0 -c n=17 -c q1=1 -c q2=3 > hexagons.Q_013.17pt.log
clingo ES_hexagons_2params.lp --configuration=frumpy -V3 -s --sat-prepro=3,size=0 -c n=17 -c q1=1 -c q2=4 > hexagons.Q_014.17pt.log
clingo ES_hexagons_2params.lp --configuration=frumpy -V3 -s --sat-prepro=3,size=0 -c n=19 -c q1=3 -c q2=4 > hexagons.Q_034.19pt.log
clingo ES_hexagons_2params.lp --configuration=frumpy -V3 -s --sat-prepro=3,size=0 -c n=20 -c q1=4 -c q2=5 > hexagons.Q_045.20pt.log

## Computational Record
The search for a configuration of 20 points excluding hexagons with 0, 4, or 5 interior points was the most demanding part of this study. 
- **Total CPU Time**: 8,018,268.840 seconds (approx. **92.8 days**).
- **Hardware**: Intel(R) Xeon(R) Gold 6226R CPU @ 2.90GHz.
- **Solver**: Clingo 5.7.1.

## Verification Note
This script is provided in its original form to ensure scientific reproducibility. It uses the `f(A,B,C,D, K)` predicate to decompose hexagons into quadrilaterals for interior point counting. For general use or further research, we recommend the refactored `ES_hexagons_ex.lp` script in the root directory.
