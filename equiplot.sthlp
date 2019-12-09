{smcl}
{* *! version 1.8  01oct2019}{...}
{viewerjumpto "Syntax" "equiplot##syntax"}{...}
{viewerjumpto "Description" "levelsof##description"}{...}
{viewerjumpto "Options" "levelsof##options"}{...}
{viewerjumpto "Remarks" "levelsof##remarks"}{...}
{viewerjumpto "Examples" "levelsof##examples"}{...}
{viewerjumpto "Stored results" "levelsof##results"}{...}
{viewerjumpto "References" "levelsof##references"}{...}
{title:Title}

{p2colset 5 21 23 2}{...}
{p2col :{manlink P equiplot} {hline 2}}Equiplot graph{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:equiplot}
{varlist}
{ifin}
, {cmd:over({varname})} [{it:options}]

{synoptset 21}{...}
{synopthdr}
{synoptline}
{synopt:{opt s:ort}}define a variable for ordering{p_end}
{synopt:{opt xtit:le}}specify a title for the x axis{p_end}
{synopt:{opt xlab:el}}defines how the values of the X axis will be displayed using Stata syntax. E.g. xlabel(20 (10) 80){p_end}
{synopt:{opt leg:title}}a title for the legend in the graph, such as "Wealth quintiles"{p_end}
{synopt:{opt noy:reverse}}plots the Y axis in increasing order. Normally the graph is plotted in reverse order.{p_end}
{synopt:{opt nocap:tion}}removes the note about ICEH{p_end}
{synopt:{opt connected}}connects all dots with a horizontal line{p_end}
{synopt:{opt dotsize(X)}}controls the size of the dots, X values should be between 1 to 5 (being 5 the biggest size){p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:equiplot} generates a dot plot mostly used to analyze inequalities between groups. Database should be organized using wide format.


{marker options}{...}
{title:Options}

{phang}
{cmd:sort} specify a sorting variable for the over variable. It can be the population size of regions or the SII for the intervention of interest, or regions of the world.

{phang}
{cmd:connected} forces that a horizontal line is drawn connecting all dots, regardless of their ordering.

{phang}
{cmd:dotsize(X)} controls the size of the dots, with X values ranging from 1 to 5 (being 5 the bigges size)


{marker examples}{...}
{title:Examples}

Plots the prevalence of the outcome in each quintile (q1-q5 variables) for each country and year (country_year variable).

{phang}{cmd:. equiplot q1 q2 q3 q4 q5, over(country_year)}{p_end}

Plots the prevalence of the outcome in each quintile (q1-q5 variables) for each year (year variable). The y axis is sorted according to the variable order, medium-sized dots are used and a horizontal line is used to connect all dots.

{phang}{cmd:. equiplot q1 q2 q3 q4 q5, over(year) sort(order) dotsize(3) xtitle("Year of the survey") legtitle("Wealth quintiles") connected}{p_end}

{marker developer}{...}
{title:Developer}
Developed by Aluisio J D Barros abarros@equidade.org; adapted by Leonardo Ferreira lferreira@equidade.org & Cauane Blumenberg cblumenberg@equidade.org (2013)
	version 1.1 - 2013 - added handling capabilities for a string or numeric over variable
	version 1.2 - 2013 - changed handling of numeric over variables to avoid re-enconding. now the order of numeric variable with label is preserved
	version 1.3 - Feb 2014 - added the sort option
	version 1.4 - Aug 2014 - added smalldots and yreverse, limited to 5 variables, better selection of the colors for less than 5 groups
	version 1.5 - July 2015 by Leonardo Ferreira - layout redesigned, removed default note, legend moved from bottom to the top of the graph, added automatic rescaling of margins
	version 1.6 - Apr 2019 by Cauane Blumenberg - added support to plot 10 variabels, automatically selects suitable colors for 2, 3, 5 and 10 variables, added connected option
	version 1.7 - May 2019 by Cauane Blumenberg - dotsize(X) option for controling the size of the dots; removed the option smalldots
	version 1.7 - May 2019 by Cauane Blumenberg - added suport to control the size of the dots ranging from 1 to 5 (being 5 the biggest size)
	version 1.8 - July 2019 by Cauane Blumenberg - fixed a bug in y axis labels when plottiong 100+ observations
	version 1.9 - October 2019 by Cauane Blumenberg - dots from poorer groups are now on top of dots from wealthier groups 
