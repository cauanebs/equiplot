/************************************************************************
This program creates a dot plot for equity analysis

Program developed by Aluisio J D Barros (2013) abarros@equidade.org
version 1.0 - 23 March 2013
version 1.1 - added handling capabilities for a string or numeric over variable
version 1.2 - changed handling of numeric over variables to avoid re-enconding. now the order of numeric variable with label is preserved
version 1.3 - Feb 2014 - added the sort option
version 1.4 - Aug 2014 - added smalldots and yreverse, limited to 5 variables, better selection of the colors for less than 5 groups
version 1.5 - July 2015 by Leonardo Ferreira - layout redesigned, removed default note, legend moved from bottom to the top of the graph, added automatic rescaling of margins
version 1.6 - Apr 2019 by Cauane Blumenberg - added support to plot 10 variabels, automatically selects suitable colors for 2, 3, 5 and 10 variables, added connected option
version 1.7 - May 2019 by Cauane Blumenberg - added suport to control the dotsize ranging from 1 to 5 (being 5 the biggest size)
version 1.8 - July 2019 by Cauane Blumenberg - fixed a bug in y axis labels when plottiong 100+ observations
version 1.9 - October 2019 by Cauane Blumenberg - bullets from poorer groups are now on top of bullets from wealthier groups 
*************************************************************************/

/************************************************************************
Usage:

equiplot varlist [if] [in], Over(y_over_num_variable) [Sort(sort_var_for_y_axis)] [XTITle(x_axis_title)] [XLABel(x_label_rule)] [LEGtitle(legend_title) [xsize(number)] [ysize(number)] [noCAPtion] [SMalldots] [noYReverse]

REQUIRED
varlist - specifies the variables that will be plotted along the line, typically coverage of an intervention for wealth quintiles
over    - specifies subgroups that will be plotted one in each line, such as countries or regions or interventions
OPTIONAL
sort    - specify a sorting variable for the over variable. It can be the population size of regions or the SII for the intervention of interest, or regions of the world.
xtitle  - a title for the x axis
xlabel  - defines how the values of the X axis will be displayed using Stata syntax. E.g. xlabel(20 (10) 80)
legtitle - a title for the legend in the graph, such as "Wealth quintiles"
ysize    - the vertical size of the graph
xsize   - the horizontal size of the graph. Combined with ysize, you can change the aspect ratio of the graph. 
nocaption - removes the note about ICEH
smalldots - draws the graph with smaller dots
noyreverse - plots the Y axis in increasing order. Normally the graph is plotted in reverse order. 
connected - adds a horizontal line connecting all equiplot dots
dotsize - values ranging from 1 (smallest) to 5 (biggest) to control the size of the dots

Example:

equiplot sba_rQ1 sba_rQ2 sba_rQ3 sba_rQ4 sba_rQ5, over(country) sort(sii) xtitle(Skilled birth attendant) ysize(16) xsize(8)

*************************************************************************/

program define equiplot
version 11.0

syntax varlist(min=2 max=10 numeric) [if] [in], Over(varname) [Sort(varname)] [XTITle(string)] [XLABel(string)] [LEGtitle(string)] [XSize(numlist max=1)] [YSize(numlist max=1)] [Option(string)] [noCAPtion] [SMalldots] [noYReverse] [connected] [dotsize(numlist max=1)]
tokenize `varlist'
tempvar overstr overnew sortvar oversort oversortn

quietly {
  preserve
  if length("`if'")>0 | length("`in'")>0 keep `if' `in'		// limit graph to selected observations
  inspect `over'
  if r(N)!=r(N_unique) | inrange(r(N_undoc),1,999) {			// variable is numeric without complete labeling or has non-unique values
  	display _newline(2) as error "Classification (over) variable either has some values unlabeled or has non-unique values" _newline "Cannot proceed!"
  	exit
  }
  if r(N)>0 {													// assuming over variable is numeric 
  	if r(N_undoc)==0 { 											// variable has labels
  	  clonevar `overnew' = `over'
  	  decode `over', gen(`overstr')								// gen string over variable
  	}
  	else {
  	  tostring `over', gen(`overstr')							// numeric variable without labels
  	  encode `overstr', gen(`overnew')							// this is to guarantee that the codes for the over variable are in sequen
  	}
  }
  else {														// assuming over variable is string
  	encode `over', gen(`overnew')								
  	clonevar `overstr' = `over'
  }
  local over `overnew'
  if "`caption'"=="" local gcaption ""Graph command by Int'l Center for Equity in Health" "www.equidade.org""
  local nlevels: word count `varlist'							// number of levels defined by varlist
  summ `over'
  local overlevels = r(N)										// number of levels of classification variable
  if "`sort'"!="" {
  	sort `sort', stable
  	local zeroes = substr("0000000000",1,length("`overlevels'"))
  	gen str `sortvar' = substr("`zeroes'",1,3-length(string(_n)))+string(_n)
  	gen str `oversort' = `sortvar'+`overstr'
  	encode `oversort', gen(`oversortn')
  	levelsof `oversortn', local(oversortnlevels)				// get all levels of sorted over variable
  	local varlab: value label `oversortn'						// get var label for sorted over variable
	foreach oversortnlevel of  local oversortnlevels {
    local vlabel: label `varlab' `oversortnlevel'				// get label for each region number
    local vlabel = regexr("`vlabel'","^([0-9]+)","")  // remove number from sorted over variable label
	  label def `varlab' `oversortnlevel' "`vlabel'", modify	// create new label for gregion based on v024 avoiding discontinous numbering and repeated labels
	}
	local over `oversortn'
  }

  if "`yreverse'" == "" local ysreverse reverse
  
  if "`xlabel'" == "" {
  	summarize `1'
  	if r(max) < 1 local xlabel = "0 (.1) 1"
  	if inrange(r(max),1.1,100) local xlabel = "0 (10) 100"
  }

  * Default layout configuration (changes if nlevels == 10)
  local legendsize "small"

  * Layout configuration for two variables
  if `nlevels' == 2 local colors `""21 53 59" "255 179 0""'

  * Layout configuration for three variables
  if `nlevels' == 3 local colors `""21 53 59" "70 145 157" "255 179 0""'           

  * Layout configuration for four variables
  if `nlevels' == 4 local colors `""21 53 59" "0 88 102" "70 145 157" "255 218 131""'

  * Layout configuration for five variables
  if `nlevels' == 5 local colors `""21 53 59" "0 88 102" "70 145 157" "255 218 131" "255 179 0""'

  * Layout configuration for ten variables
  if `nlevels' == 9 {
    local colors `""32 30 30" "12 68 78" "65 91 97" "25 105 117" "115 160 167" "255 231 173" "255 205 88" "213 182 112" "195 139 9""'            // colors to be used in the graph  
    local legendsize "vsmall"
  }

  * Layout configuration for ten variables
  if `nlevels' == 10 {
    local colors `""32 30 30" "12 68 78" "65 91 97" "25 105 117" "57 118 127" "115 160 167" "255 231 173" "255 205 88" "213 182 112" "195 139 9""'            // colors to be used in the graph  
    local legendsize "vsmall"
  }

  if "`dotsize'" == "5" local nomdotsize = "huge"
  if "`dotsize'" == "4" local nomdotsize = "vlarge"
  if "`dotsize'" == "3" local nomdotsize = "large"
  if "`dotsize'" == "2" local nomdotsize = "medlarge"
  if "`dotsize'" == "1" local nomdotsize = "medium"
  if "`dotsize'" == "" local nomdotsize = "huge"

  if "`connected'" != "" {
    * Horizontal line connecting markers
    levelsof `over', local(overcontents)
    local varlistcomma = subinstr("`varlist'", " ", ",", `nlevels'-1)
    foreach o of local overcontents {
      local minvalue = min(`varlistcomma') in `o'
      local maxvalue = max(`varlistcomma') in `o'
       
      local horzline `horzline' scatteri `o' `minvalue' `o' `maxvalue', connect(l) lcolor("navy") m(none) ||
      macro drop minvalue maxvalue  
    }
  }

  local margins "20 20 12 12 10 8 8"
  local plotdist : word `overlevels' of `margins'
  if `overlevels' > 7 local plotdist 5
  
  local ncolor 1
  local nvar 1
  local order = `nlevels'+1
  foreach variable of local varlist {
  	*local order = `nvar'+1
  	local label: var label `variable' 
  	local legend `legend' `order' "`label'"
  	local color: word `ncolor' of `colors'
  	if `nvar'==`nlevels' local scatter sc `over' `variable', mlwidth(none) mcolor("`color'") msize("`nomdotsize'") `scatter' // last variable in the list
  	else local scatter || sc `over' `variable', mlwidth(none) mcolor("`color'") msize("`nomdotsize'") `scatter'
  	local ++ncolor
  	local ++nvar
    local --order
  }
  
  graph set window fontface "Calibri"
  *** here we put together the pieces that make the full graph command and save it to the grcommand macro
  local grcomm1 twoway rcap  `1' ``nlevels'' `over', hor ylabel(1/`overlevels',valuelabels angle(horizontal) labsize (medsmall) labcolor("0 88 102") tlcolor("0 88 102") glcolor(bluishgray)) xlabel(`xlabel',labsize(small) tlcolor("0 88 102") labcolor("0 88 102")) xtitle(`xtitle', color("0 88 102") margin(small)) ytitle("") graphregion(color("225 237 239")) plotregion(margin("l=2 r=2 b=`plotdist' t=`plotdist'")) ||
  local grcomm2 xsize(`xsize') ysize(`ysize')  yscale(`ysreverse' lcolor("0 88 102") lwidth(medium)) xscale(lcolor("0 88 102") lwidth(medium)) legend(order(`"`legend'"')  size(`legendsize') rows(1) title(`legtitle', size(medsmall) color("0 88 102")) position(12) region(color(none))) `option'
  local grcommand `grcomm1' `scatter' `grcomm2'       
  *local grcommand `grcomm1' `scatter' || `horzline' `scatter' `grcomm2'  

  noisily display _newline as text "Command generated by the procedure:" _newline as result `"`grcommand'"' _newline as text " `o' Thanks for using equiplot - Int'l Center for Equity in Health (www.equidade.org)"
  `grcommand'
  restore
}

end

