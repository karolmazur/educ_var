clear all
use "individual_all.dta"

egen maxage = max(age), by(memberid_new)
drop if maxage > 18 // keep only children

drop if yr_stop_edu == . | yr_stop_edu < 2009 // keep only dropouts after 2009
tab yr_stop_edu

egen maxyear = max(year), by(memberid_new) // the final year of observation of each individual
keep if maxyear == year // only keep the final year of observation for each individual

tab yrs_edu

tab rea_stop_edu
