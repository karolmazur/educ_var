* Peter Xue
* This file cleans HCS 2014-7.1.Govt_prog_participation.xlsx
* This version: 2023-06


clear all
set more off

*** Change the working directory before running the .do file ***

global filepath = "C:/Users/user/Desktop/educ_var" 

	
* import the full dataset
import excel "$filepath/orig_data/2014/hcs/7.1.Govt_prog_participation.xlsx", firstrow clear
	
destring *, replace

* reorganize CHS_ID
gen country = substr(CHS_ID,1,1)
gen state = substr(CHS_ID,2,2)
gen village = substr(CHS_ID,6,1)
gen household = substr(CHS_ID,7,4)

gen hhid = country + "-" + state + "-" + village + "-" + household
order CHS_ID hhid country state village household
replace vil = state + "-" + village

* create memberid
rename *, lower
rename sr_no sl_no
tostring sl_no, gen(sl_no_str)
gen memberid = country + "-" + village + "-" + household + "-" + sl_no_str

* reorder variables
local tokeep "hhid chs_id memberid sl_no country state village household money_earned_2009 amt_earned_2010 amt_earned_2011 amt_earned_2012 amt_earned_2013"
keep `tokeep'
order `tokeep'

* isolate 09-13 amount
forvalues y = 2009/2013 {
	if `y' == 2009 {
	preserve
	keep hhid chs_id memberid sl_no country state village household money_earned_`y'
    save "$filepath/temp_data/govt_prog_amount_`y'.dta", replace
	restore
	}
	
	if `y' > 2009 {
	preserve
	keep hhid chs_id memberid sl_no country state village household amt_earned_`y'
    save "$filepath/temp_data/govt_prog_amount_`y'.dta", replace
	restore
	}
}

* compute total amount of benefits for each household in a given year
** 2009
clear
use "$filepath/temp_data/govt_prog_amount_2009.dta"
bysort hhid: egen total_2009 = sum(money_earned_2009)
duplicates drop hhid, force
keep hhid money_earned_2009
rename money_earned_2009 amt_earned_2009
save "$filepath/temp_data/govt_prog_amount_2009.dta", replace

** 2010-2013
forvalues y = 2009/2013{
	clear
	use "$filepath/temp_data/govt_prog_amount_`y'.dta"
	bysort hhid: egen total_`y' = sum(amt_earned_`y')
	duplicates drop hhid, force
	keep hhid amt_earned_`y'
	save "$filepath/temp_data/govt_prog_amount_`y'.dta", replace
}

* merge total amount of benefits for each household from 09-13
clear
use "$filepath/temp_data/govt_prog_amount_2009.dta"
forvalues y = 2010/2013{
 merge 1:m hhid using "$filepath/temp_data/govt_prog_amount_`y'.dta"
 drop _merge
}

* transform wide to long
forvalues y = 2009/2013{
	rename amt_earned_`y' amt_earned`y'
}
reshape long amt_earned, i(hhid) j(year)
rename amt_earned gov_prog_amount_total
save "$filepath/temp_data/hh_govt_prog_amount.dta", replace


* erase temp data
forvalues y = 2009/2013{
	erase "$filepath/temp_data/govt_prog_amount_`y'.dta"
}


