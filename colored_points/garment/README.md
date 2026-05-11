# Garment Numbers Solver (ASP)

This repository contains an Answer Set Programming (ASP) encoding for finding **Garment Numbers** in colored point sets. 

The task is to find the minimum number of points $n$ such that any 2-coloring of $n$ points in general position contains a monochromatic empty "garment" of a given type.

## Technical Details

- **Model:** The encoding uses **monotone signotopes** (x-sorted point sets) to represent order types. This allows for an efficient exhaustive search over all topological configurations.
- **Emptiness Definition:** Following the implementation logic found in the original authors' repository, this solver defines a garment as "empty" if it contains **no other points** of the set (Strongly Empty), regardless of color. 
- **Methodology:** The approach for modeling order types via signotopes and symmetry breaking is based on the methodology described in the author's work on SAT/ASP modeling.

## Garment Types
The solver supports the following structures as defined in the literature:
- Cravat
- Necklace
- Bowtie
- Skirt
- Pant

## Usage

### Finding Coordinates (Linear Subreduction Method)
To find a valid point set realization for a counterexample:
```bash
clingo-lpx lpx ES_garment.lp --configuration=frumpy -V3 -s -c red1=bowtie -c red2=skirt -c blue1=bowtie -c blue2=skirt -c n=13 > bowtie-skirt-13pt.xy
clingo-lpx lpx ES_garment.lp --configuration=frumpy -V3 -s -c red1=necklace -c red2=pant -c blue1=necklace -c blue2=pant -c n=12 > necklace-pant-12pt.xy
clingo-lpx lpx ES_garment.lp --configuration=frumpy -V3 -s -c red1=necklace -c red2=skirt -c blue1=necklace -c blue2=skirt -c n=14 > necklace-skirt-14pt.xy
clingo-lpx lpx ES_garment.lp --configuration=frumpy -V3 -s -c red1=necklace -c blue1=necklace -c n=15 > necklace-15pt.xy
```

### Proving Upper Bound (ASP)
To prove that a garment must exist for a given $n$:
```bash
clingo ES_garment.lp --configuration=frumpy -V3 -s -c red1=bowtie -c blue1=bowtie -c n=14 > bowtie-14pt.unsat
clingo ES_garment.lp --configuration=frumpy -V3 -s -c red1=necklace -c red2=pant -c blue1=necklace -c blue2=pant -c n=13 > necklace-pant-13pt.unsat
clingo ES_garment.lp --configuration=frumpy -V3 -s -c red1=necklace -c red2=skirt -c blue1=necklace -c blue2=skirt -c n=15 > necklace-skirt-15pt.unsat
clingo ES_garment.lp --configuration=frumpy -V3 -s -c red1=necklace -c blue1=necklace -c n=16 > necklace-16pt.unsat
```

## Results
The solver allows for precise determination of garment numbers:
- $\mathcal G(\textrm{bowtie}) = $\mathcal G(\textrm{bowtie}\vee \textrm{skirt})=14$
- $\mathcal G(\textrm{necklace}\vee \textrm{pant})=13$
- $\mathcal G(\textrm{necklace}\vee \textrm{skirt})=15$
- $\mathcal G(\textrm{necklace})=16$

## References

- **Garment Numbers:** O. Aichholzer et al., *"Garment numbers of bi-colored point sets in the plane"* (2026). [arXiv:2603.05339](https://arxiv.org)
- **Methodology:** V. Koshelev, *"Combinatorial Geometry of Erdos--Szekeres Type Problems: SAT/ASP Modeling and Linear Subreduction"* (2026). [arXiv:2604.20120](https://arxiv.org)
- **Authors' Code Reference:** [N-Coder/garment-numbers-colored-point-sets](https://github.com)
