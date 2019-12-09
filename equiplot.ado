program define equiplot
version 11.0

syntax varlist(min=2 max=10 numeric) [if] [in], Over(varname) [Sort(varname)] [XTITle(string)] [XLABel(string)] [LEGtitle(string)] [XSize(numlist max=1)] [YSize(numlist max=1)] [Option(string)] [noCAPtion] [noYReverse] [connected] [dotsize(numlist max=1)]
tokenize `varlist'
tempvar overstr overnew sortvar oversort oversortn

quietly {
  preserve
  if length("`if'")>0 | length("`in'")>0 keep `if' `in'		// Limit graph to selected observations using if/in
  inspect `over'
  if r(N)!=r(N_unique) | inrange(r(N_undoc),1,999) {			// Checks if variable is numeric without complete labeling or if it has non-unique values
  	display _newline(2) as error "Classification (over) variable either has some values unlabeled or has non-unique values" _newline "Cannot proceed!"
  	exit
  }
  if r(N)>0 {													// Assuming over variable is numeric 
  	if r(N_undoc)==0 { 											// Variable has labels
  	  clonevar `overnew' = `over'
  	  decode `over', gen(`overstr')								// Transforms the numeric variable into a string variable
  	}
  	else {
  	  tostring `over', gen(`overstr')							// If it is a numeric variable, but has no labels
  	  encode `overstr', gen(`overnew')							
  	}
  }
  else {														// Assuming over variable is string
  	encode `over', gen(`overnew')								
  	clonevar `overstr' = `over'
  }
  local over `overnew'
  if "`caption'"=="" local gcaption ""Graph command by Int'l Center for Equity in Health" "www.equidade.org""
  local nlevels: word count `varlist'							// Number of levels defined by the number of variables in varlist
  summ `over'
  local overlevels = r(N)										// Number of levels of classification variable
  if "`sort'"!="" {
  	sort `sort', stable
  	local zeroes = substr("0000000000",1,length("`overlevels'"))
  	gen str `sortvar' = substr("`zeroes'",1,3-length(string(_n)))+string(_n)
  	gen str `oversort' = `sortvar'+`overstr'
  	encode `oversort', gen(`oversortn')
  	levelsof `oversortn', local(oversortnlevels)				// Get all levels of sorted over variable
  	local varlab: value label `oversortn'						// Get var label for sorted over variable
	foreach oversortnlevel of  local oversortnlevels {
    local vlabel: label `varlab' `oversortnlevel'				
    local vlabel = regexr("`vlabel'","^([0-9]+)","")  // Remove number from sorted over variable label
	  label def `varlab' `oversortnlevel' "`vlabel'", modify	
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
  	local label: var label `variable' 
  	local legend `legend' `order' "`label'"
  	local color: word `ncolor' of `colors'
  	if `nvar'==`nlevels' local scatter sc `over' `variable', mlwidth(none) mcolor("`color'") msize("`nomdotsize'") `scatter' // Last variable in the list
  	else local scatter || sc `over' `variable', mlwidth(none) mcolor("`color'") msize("`nomdotsize'") `scatter'
  	local ++ncolor
  	local ++nvar
    local --order
  }
  
  graph set window fontface "Calibri"
  local grcomm1 twoway rcap  `1' ``nlevels'' `over', hor ylabel(1/`overlevels',valuelabels angle(horizontal) labsize (medsmall) labcolor("0 88 102") tlcolor("0 88 102") glcolor(bluishgray)) xlabel(`xlabel',labsize(small) tlcolor("0 88 102") labcolor("0 88 102")) xtitle(`xtitle', color("0 88 102") margin(small)) ytitle("") graphregion(color("225 237 239")) plotregion(margin("l=2 r=2 b=`plotdist' t=`plotdist'")) ||
  local grcomm2 xsize(`xsize') ysize(`ysize')  yscale(`ysreverse' lcolor("0 88 102") lwidth(medium)) xscale(lcolor("0 88 102") lwidth(medium)) legend(order(`"`legend'"')  size(`legendsize') rows(1) title(`legtitle', size(medsmall) color("0 88 102")) position(12) region(color(none))) `option'
  local grcommand `grcomm1' `scatter' `grcomm2'       

  noisily display _newline as text "Command generated by the procedure:" _newline as result `"`grcommand'"' _newline as text " `o' Thanks for using equiplot - Int'l Center for Equity in Health (www.equidade.org)"
  `grcommand'
  restore
}

end

