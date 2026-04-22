# Original Experimental Results

This directory contains the original source code and execution logs used to obtain the computational results presented in the paper. 

## Contents
- `ES_hexagons_sub4_original.lp`: The exact ASP (Clingo) script that was used for the final 214-day computation of ~h_sub(6,4). Originally named ES_hexagons_mod.lp during the experiments.
   Experiments and output logs:
clingo ES_hexagons_mod.lp --configuration=frumpy -V3 -s --sat-prepro=3,size=0 -c n=18 -c q=2 > hexagons.sub4.q2.18.log
clingo ES_hexagons_mod.lp --configuration=frumpy -V3 -s --sat-prepro=3,size=0 -c n=20 -c q=3 > hexagons.sub4.q3.20.log
clingo ES_hexagons_mod.lp --configuration=frumpy -V3 -s --sat-prepro=3,size=0 -c n=21 -c q=4 > hexagons.sub4.q4.21.log

## Verification Note
The source code in this directory is provided "as-is" for the purpose of scientific reproducibility and verification. Unlike the refactored version in the root directory, this script remains exactly as it was during the 214-day run. 

### Key differences from the refactored version:
1. **Explicit Constraints**: Instead of using pooling syntax, this version uses 32 explicit "flat" rules to define ~h_sub constraints across all 8 combinatorial types of convex hexagons.
2. **Naming Conventions**: Variables and predicates follow the initial development naming scheme (e.g., using `N` instead of `I` for interior points).
3. **Redundancy**: Some auxiliary predicates (like `rotation`) are defined explicitly to ensure predictable grounding.

## Computational Resources
The 214-day CPU time was recorded on Intel(R) Xeon(R) Gold 6226R CPU @ 2.90GHz running Clingo 5.7.1. For any new experiments or extensions of this work, we recommend using the optimized script located in the root of this repository.
