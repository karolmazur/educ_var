# educ_var-2023-06

The markdown file explains what is in the folders above.

The main branch contains all files in 2023-06 (the initial version).

The education-related variables in the two data reports are:

| **Variable No.** | **Variables**                                                         | **Source**                                                                                                                                                                                          |
| ---------------- | --------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1                | hh member’s years of education                                        | GES- `A.Household_details. xlsx`                                                                                                                                                                      |
| 2                | hh member’s education level                                           | GES- `A.Household_details. xlsx`                                                                                                                                                                     |
| 3                | the reasons why hh member dropped education                           | GES- `A.Household_details. xlsx`                                                                                                                                                                     |
| 4                | hh member’s main and subsidiary occupation                            | GES- `A.Household_details. xlsx`                                                                                                                                                                      |
| 5                | weight and height (used for computing BMI)                            | GES- `A.Household_details. xlsx`(not available in 2009)                                                                                                                                             |
| 6                | average amount of gov’t benefits that households received             | HCS 2014-`7.1.Govt_prog_participation.xlsx`                                                                                                                                                           |
| 7                | hh education expenditure (fee, books, stationary, transport, uniform) | Transaction-`Non_food_items. xlsx` (2009,2010,2011,2014) and `Non_food_items_AP. xlsx`, `Non_food_items_GJ. xlsx`, `Non_food_items_KN. xlsx`, `Non_food_items_MH. xlsx`, `Non_food_items_MP. xlsx` (2012, 2013) |



All data are in the folder “temp_data”. 

Variables 1-5 are in `individual_head_educ.dta`, `individual_son_educ.dta`, and `individual_daughter_educ.dta`.

Variable 6 is in `hh_govt_prog_amount.dta`.

Variable 7 is in `hh_educ_expen.dta`.

To generate these datasets, run the file `run_all.do`.

The procedure of obtaining these datasets is summarized as follows. All .do files are in the folder “do_files”. Original data are in the folder “orig_data” (the same as the one in the Dropbox folder).

## Part 1: GES - household details
### A. data cleaning
 See `clean_GES_hh_details.do`.  The output is `individual_all.dta`. It contains all household members from 2009-2014, but not all members appear in each year. 
### B. Generate family member education data
See `gen_GES_educ.do`. The output is `individual_head_educ.dta`, `individual_son_educ.dta`, and `individual_daughter_educ.dta`. They include education-related information for household heads and their children (son + daughter) from 2009-2014, but not all members appear in each year.

## Part 2: HCS 2014- Government benefit amount
 See `clean_HCS_2014_govt_prog.do`. The original dataset is individual-level government benefits received from 2009-2013.  I aggregate the amount on the household-level for each year. The output is `hh_govt_prog_amount.dta`. 

## Part 3: Transaction module – non-food expenditure - education expenses
See `clean_transaction_educ.do`. The original datasets are household-level non-food expenditure from 2009-2014.  The output is `hh_educ_expen.dta`. 



This is the readme file.
