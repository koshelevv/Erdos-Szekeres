Combinatorial Geometry: Convex Hexagons and Erdos--Szekeres Problems

This repository contains the source code and computational results for the study of convex hexagons with interior points. We use Answer Set Programming (ASP) to explore signotopes and Linear Programming (LP) relaxation to find geometric realizations (coordinates).

Key Results
 * ~h_sub(6, q): Established exact values for q in {2, 3, 4}.
 * ~h_ex(6, Q): Determined minimum point counts for various sets Q (where 0 is in Q).
 * Computational Records: One of the searches required over 214 days of CPU time, and another over 92 days.
 * Structural Theorems: Proven mandatory existence of specific hexagon types in configurations of 17-20 points.

Repository Structure

Core Scripts (Root Directory)
 * ES_hexagons_sub4.lp: Optimized ASP script for the ~h_sub(6, q) problem. Uses pooling syntax for maximum performance.
 * ES_hexagons_ex.lp: Refactored ASP script for the ~h_ex(6, Q) problem (hexagons with an exact number of interior points from set Q).

Experimental Archives
 * original_run/: Contains the original script (ES_hexagons_mod.lp) and logs for the 214-day ~h_sub computation.
 * original_ex/:  Contains the original script (ES_hexagons_2params.lp) and logs for the 92-day ~h_ex computation.

Usage
To run the scripts, you need the clingo solver (part of the Potassco suite).

bash
# Example: Search for a signotope on 18 points with no q=2 sub-structures
clingo ES_hexagons_sub4.lp --configuration=frumpy --sat-p=3,size=0 -V3 -s -c q=2 -c n=18

