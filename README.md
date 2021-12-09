# Numeric tests for "A branch-and-prune algorithm for discrete player convex Nash equilibrium problems"

## Reproduce the results
- The tests for this paper can be reproduced by running testwholealgorithm.m. Make sure that the folder ma_numeric is opened in MATLAB or you need to specify the path to IntegerPrograms/TestSet1 from your current directory.
- After having run the computations, the results can be summarized in a table by running getResults.m.

## The Test-Sets
The tests are performed on the instances in the folder TestSet1, the table with the problem properties can be reproduced by running getProperties.m.

---
## Data in /results 
The data printed in the thesis are contained in:
- resultsB1 : Instances 1-15  from TestSet1
- resultsB2 : Instances 16-24 from TestSet1
- resultsB3 : Instances 25-30 from TestSet1
-> In B3 sind auch alle Instanzen aus den vorherigen Läufen!
-> mit getResults lassen sich die Tabellen wieder generieren