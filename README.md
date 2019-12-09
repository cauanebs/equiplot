# equiplot
Command used to plot a sort of dot graph used to analyzed prevalence or coverage inequalities according to a stratifier.

## Installation
Perform the following steps to install Stata ado files:

1. Open Stata
2. Type personal in the command line and hit enter to discover the location of your personal ado folder
3. Navigate to the personal ado folder (if after navigating there is no folder called personal, create one)
4. Place the ado and sthlp files into your personal ado folder

## Version history
#### Version 1.0
+ 1.0. First `equiplot` version; (2013 - Aluisio JD Barros)
+ 1.1. Added handling capabilities for a string or numeric over variable (2013 - Aluisio JD Barros)
+ 1.2. Changed handling of numeric over variables to avoid re-enconding. Now the order of numeric variable with label is preserved (2013 - Aluisio JD Barros)

#### Version 2.0
+ 2.0. Added the `sort` option (Feb 2014 - Aluisio JD Barros)
+ 2.1. Added `smalldots` and `yreverse`, limited to 5 variables, better selection of the colors for less than 5 groups (Aug 2014 - Aluisio JD Barros)
+ 2.5. Layout redesigned, removed default note, legend moved from bottom to the top of the graph, added automatic rescaling of margins (Jul 2015 - Leonardo Ferreira)
	
#### Version 3.0
+ 3.1. Added support to plot 10 variabels, automatically selects suitable colors for 2, 3, 5 and 10 variables, added connected option (Apr 2019 - Cauane Blumenberg)
+ 3.2. `dotsize(X)` option for controling the size of the dots; removed `smalldots` (May 2019 - Cauane Blumenberg)
+ 3.3. Fixed a bug in y axis labels when plottiong 100+ observations (Jul 2019 - Cauane Blumenberg)
+ 3.4. Dots from poorer groups are now on top of dots from wealthier groups (Oct 2019 - Cauane Blumenberg)

## Developer
The `equiplot` command was first developed by Aluisio JD Barros, PhD. It is now mantained by Cauane Blumenberg, PhD.
