clear all
set more off
pause on
/**********************************
CREATED BY: Danton Noriega 09/11/2015

DESC:
- Load files from directory `input_dir'
- create new `id` variable which matches the filename e.g.
    file = "ab2.csv" would be imported then generated new ver `gen id = "ab2"`
- export stacked file to dir `output_dir' with name `stacked_files'.dta
*************************************/

local main_dir "/Users/dnoriega/Dropbox/meter"
local input_dir "`main_dir'"
local output_dir "`main_dir'/dta/"
local output_file "stacked_files"

* get file names from directory
cd `input_dir'
local allfiles : dir . files "*csv"

* strip csv
local strp_csv ""
local count = 0
foreach f of local allfiles {
    if(regexm("`f'", "(.*)\.csv")) {
        local strp_csv = "`strp_csv'" + regexs(1) + " "
    }
}
di "`strp_csv'"
di "`count'"

local first 1
tempfile hold
tempfile temp
local count = 0
* input data and convert names
foreach f of local allfiles {
     * strp csv from file name
    if(regexm("`f'", "(.*)\.csv")) local strp_csv = regexs(1)
    qui import delimited `f', delimiter(comma) varnames(1) clear
    di "`strp_csv'"
    local count = `count' + 1
    di "`count'"
     * if first file, save copy
    if(`first' == 1) {
        local first 0
        gen id = "`strp_csv'"
        save `hold', replace
    }
     * if NOT first file, merge then update
    else {
        gen id = "`strp_csv'"
        save `temp', replace
        use `hold', clear
        append using `temp'
        save `hold', replace
    }
}
cd `output_dir'
saveold "`output_file'.dta", replace
