clear all
set more off
pause on
/**********************************
CREATED BY: Danton Noriega 09/11/2015

DESC:
- Load files from directory `input_dir'
- merge all files on variable(s) `keys' e.g. if merge keys are i, t
    then the one would write: local keys "i t"
- append variables of each file with suffix of "filename" e.g.
    file = "ab2.csv" with vars "x", "y" become "x_ab2" and "y_ab2".
    NOTE: this EXCLUDES the keys, which should be shared across all files.
- export stack file to dir `output_dir' with name `stack_rename'.dta
*************************************/

local main_dir "~/GitHub/stack_id_using_filenames"
local input_dir "~/GitHub/stack_id_using_filenames/sample_data/"
local output_dir "`main_dir'/stacked_data/"
local output_file "stacked_renamed"

/* get file names from directory */
cd `input_dir'
local allfiles : dir . files "*csv"

local first 1
tempfile hold
tempfile temp
/* input data and convert names */
foreach f of local allfiles {
     * strp csv from file name
    if(regexm("`f'", "(.*)\.csv")) local strp_csv = regexs(1)
    import delimited `f', clear
     * if first file, save copy
    if(`first' == 1) {
        local first 0
        gen id = "`strp_csv'"
        save `hold', replace
    }
     * if NOT first file, merge then update
    else {
        save `temp', replace
        use `hold', clear
        append using `temp'
        save `hold', replace
    }
}
cd `output_dir'
saveold "`output_file'.dta", replace
