This repository contains point configurations and abstract signotopes obtained during an extensive computational experiment.
The data focuses on the classification and existence of empty convex hexagons by their types in planar point sets.

## Overview

The dataset is divided into two main categories:
1.  **Geometric Realizations (`.xy` files)**: Sets of points with integer coordinates.
    Some files contain "nested" configurations (e.g., subsets of points provide different properties).
2.  **Abstract Signotopes (`.ast` files)**: Combinatorial structures for which no geometric realization is currently known.

## Data Files

### 1. Geometric Configurations (.xy)


| Filename                   |  N    | Description                                                                     | Method                   |
| :------------------------- | :---: | :------------------------------------------------------------------------------ | :----------------------- |
| `h_sub_q3_N19.xy`          |  19   | Realization for $h_{sub}(6,3) = 20$                                             | Linear Subreduction (Z3) |
| `h_sub_q4_N20.xy`          |  20   | Realization for $h_{sub}(6,4) = 21$                                             | Linear Subreduction (Z3) |
| `hex_types_0_uniq_N17.xy`  | 16-18 | **3-in-1**: $N=18$ (min 2 hex 0);     $N=17$ (1 hex 0); $N=16$ (ES-config)      | Manual                   |
| `hex_types_01_uniq_N18.xy` | 17-18 | **3-in-1**: $N=18$ (min 2 hex: 0, 1); $N=17$ pts 1-17 (hex 0); pts 2-18 (hex 1) | clingo-lpx               |
| `hex_types_1_uniq_N17.xy`  |  17   | Configuration with exactly one hexagon of type 1                                | Linear Subreduction (Z3) |
| `hex_types_12_N18.xy`      |  18   | Points containing only types 1-2                                                | Linear Subreduction (Z3) |
| `hex_types_123_N19.xy`     |  19   | Points containing only types 1-3                                                | Stochastic Search        |
| `hex_types_1234_N20.xy`    |  20   | Points containing only types 1-4                                                | Stochastic Search        |
| `hex_types_234567_N17.xy`  |  17   | Points containing only types 2-7, no 0-1                                        | Linear Subreduction (Z3) |
| `hex_types_234_N17_min.xy` |  17   | Minimal number of hexagons (9), if types 0-1 are forbidden; types 2-4 only      | clingo-lpx               |

### 2. Multi-fold (k-fold) Configurations


| Filename                         |  N    | Property                                                                                       | Method            |
| :------------------------------- | :---: | :--------------------------------------------------------------------------------------------- | :---------------- |
| `hex_types_1234567_N22_3fold.xy` | 18-22 | **3-in-1**: $N=22$ (3-fold, types 1-7); $N=19$ (3-fold, types 1-4); $N=18$ (3-fold, types 1-4) | Stochastic Search |
| `hex_types_1234567_N21_5fold.xy` | 20-21 | **2-in-1**: $N=21$ (5-fold, types 1-7); $N=20$ (5-fold, types 1-6)                             | Stochastic Search |
| `hex_types_123456_N21_3fold.xy`  |  21   | 3-fold configuration, types 1-6                                                                | Stochastic Search |

### 3. Abstract Signotopes (.ast)

These files represent combinatorial abstractions found via **clingo**. As of the current state of the experiment,
   **no geometric realization has been found** for these structures.

*   `hex_types_1235_N20.ast`      : Abstract signotope for $N=20$ containing only types 1,2,3,5.
*   `hex_types_124_N19_3fold.ast` : 3-fold abstract signotope for $N=19$ containing only types 1,2,4.

---

## Symmetry and Optimality

It is important to note that the point configurations marked as k-fold or symmetric are **not necessarily extremal**. 

While these sets satisfy the specific constraints on hexagon types for a given $N$, they do not formally guarantee
the minimization of the number of hexagon types or the total count of hexagons. The search was primarily focused
on finding **symmetric examples**; these files represent the successful results of that targeted search and
may not reflect the absolute lower bounds for the respective $N$.


## Methodology
The search for these structures involved several computational techniques:
*   **Local Stochastic Search**: Used for discovering symmetric configurations and several easy cases.
*   **Linear Subreduction**: A method to realize abstract order types using the **Z3 SMT solver**.
*   **clingo-lpx** to handle configurations with cardinality constraints and minimization.
*   **Answer Set Programming (ASP)**: Using **clingo** for found signotopes.
