{smcl}
{* *! version 3.4  01oct2019}{...}
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
{synopt:{opt connected}}connects all dots with a horizontal line{p_end}
{synopt:{opt dotsize(#)}}controls the size of the dots, # can assume values between 1 to 5, being 5 the biggest dot size{p_end}
{synopt:{opt leg:title(string)}}a title for the legend of the graph, such as "Wealth quintiles"{p_end}
{synopt:{opt nocap:tion}}removes the note about ICEH{p_end}
{synopt:{opt noy:reverse}}plots the Y axis in increasing order; normally the graph is plotted in reverse order{p_end}
{synopt:{opt o:ption(string)}}optional string containing further twoway graph options{p_end}
{synopt:{opt s:ort({varname})}}define a variable for ordering{p_end}
{synopt:{opt xlab:el(string)}}defines how the values of the X axis will be displayed using Stata syntax; e.g. xlabel(20 (10) 80){p_end}
{synopt:{opt xtit:le(string)}}specify a title for the x axis{p_end}
{synopt:{opt xsize(#)}}controls the width of the plot area{p_end}
{synopt:{opt ysize(#)}}controls the height of the plot area{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:equiplot} generates a dot plot mostly used to compare prevalence/coverage of an outcome according to the levels of a stratifier, and to analyze inequalities between these groups. The database should be organized using wide format.


{marker options}{...}
{title:Options}

{phang}
{cmd:sort} specifies a sorting variable that controls in which order the information on the y axis will be displayed.

{phang}
{cmd:connected} forces that a horizontal line is drawn connecting all dots, regardless of their ordering.

{phang}
{cmd:dotsize(X)} controls the size of the dots, with X values ranging from 1 to 5 (being 5 the bigges size).


{marker examples}{...}
{title:Examples}

Plots the prevalence of the outcome in each quintile (q1-q5 variables) for each country and year (country_year variable).

{phang}{cmd:. equiplot q1 q2 q3 q4 q5, over(country_year)}{p_end}

Plots the prevalence of the outcome in each quintile (q1-q5 variables) for each year (year variable). The y axis is sorted according to the variable order, medium-sized dots are used and a horizontal line is used to connect all dots.

{phang}{cmd:. equiplot q1 q2 q3 q4 q5, over(year) sort(order) dotsize(3) xtitle("Year of the survey") legtitle("Wealth quintiles") connected}{p_end}

{marker developer}{...}
{title:Developer}
Developed by Aluisio JD Barros, PhD (abarros@equidade.org); 
Adapted by Cauane Blumenberg, PhD (cblumenberg@equidade.org) & Leonardo Ferreira, MSc (lferreira@equidade.org);
Currently mantained by Cauane Blumenberg, PhD (cblumenberg@equidade.org).

