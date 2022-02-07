# Numeric tests for "A branch-and-prune algorithm for discrete player convex Nash equilibrium problems"

## Reproduce the results
- The tests for this paper can be reproduced by running testwholealgorithm.m. Make sure that the folder ma_numeric is opened in MATLAB or you need to specify the path to IntegerPrograms/TestSet1 from your current directory.
- After having run the computations, the results can be summarized in a table by running getResults.m.

## The Test-Sets
The tests are performed on the instances in the folder TestSet1, the table with the problem properties can be reproduced by running getProperties.m.
TestSet1: On these testsets, my master's thesis results were computet
TestSet3: New method for generating test-instances (different signs and zeros in goalfunctions)
TestSet5: Non-convex Objective functions (Q not positive definite, but diagonal entries are positive)

## Data in /results
The data printed in the thesis are contained in:

- resultsB1 : Instances 1-15  from TestSet1
- resultsB2 : Instances 16-24 from TestSet1
- resultsB3 : Instances 25-30 from TestSet1
- resultsNC : Non-convex instances from TestSet5

Important:

- resultsB3 also contains all data from resultsB1&B2
- The tables in resultsB3 are in a different order than the tables in the thesis
- run getResults.m to generate the latex tables
