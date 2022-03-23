# Numeric tests for "A branch-and-prune algorithm for discrete Nash equilibrium problems"

## Reproduce the results
- The tests for this paper can be reproduced by running testwholealgorithm.m. Make sure that the folder nep_pruning is opened in MATLAB or you need to specify the path to the respective test bed from your current directory.
- The data-structure used to store the Nash equilibrium problems is described in branchingmethod.m
- After having run the computations, the results can be summarized in a table by running getResults.m (run getProperties.m before).

## The test bed
The tests are performed on the instances in the folder IntegerPrograms. We have subfolders for the convex test bed and the non-convex test bed.

## Data in /results
The data printed in the paper is contained in:

- results/convex.mat
- results/nonconvex.mat
- load the result-file and run getProperties.m and getResults.m to generate the latex tables
