clear all
set more off
pause off
/**********************************
CREATED BY: Danton Noriega 09/11/2015

DESC:
- Load files from directory `input_dir'
- append variables of each file with suffix of "filename" e.g.
file = "ab2.csv" with vars "x", "y" become "x_ab2" and "y_ab2"
- merge all files on variable `key'
- export merged file to `output_dir'
*************************************/

local main_dir "~/GitHub/merge_rename_using_filenames/"
local input_dir "~/GitHub/merge_rename_using_filenames/sample_data/"
local output_dir "`main_dir'/merged_data/"
local keys "i t"

/* get file names from directory */
cd `input_dir'
local allfiles : dir . files "*csv"

/* strip csv */
local strp_csv ""
foreach f of local allfiles {
    if(regexm("`f'", "(.*)\.csv")) {
        local strp_csv = "`strp_csv'" + regexs(1) + " "
    }
}
di "`strp_csv'"

local first 1
tempfile hold
tempfile temp
/* input data and convert names */
foreach f of local allfiles {
     * strp csv from file name
    if(regexm("`f'", "(.*)\.csv")) local strp_csv = regexs(1)
    * di "`strp_csv'"
    import delimited `f', clear
     * get list of vars
    local vars ""
    foreach v of varlist _all {
        local vars = "`vars'" + "`v' "
        * di "`vars'"
    }
     * remove keys and rename
    local vars_nokey : list vars - keys
    foreach v of local vars_nokey {
        rename `v' `v'_`strp_csv'
    }
     * if first file, save copy
    if(`first' == 1) {
        local first 0
        save `hold', replace
    }
     * if NOT first file, merge then update
    else {
        save `temp', replace
        use `hold', clear
        merge m:1 `keys' using `temp', nogen
        save `hold', replace
    }
}
cd `output_dir'
saveold "merged_renamed.dta", replace
