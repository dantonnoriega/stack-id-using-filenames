## gen_sample_data.R
## INPUTS: output dirtory
## OUTPUTS: a bunch of fake data sets with different names with
## - id = i, time = t, x, y
gen_sample_data <- function(out_dir = file.path("~/Github/merge_rename_using_filenames/sample_data/")) {

    lbls <- paste0(LETTERS[1:5], LETTERS[6:10], c(1:5))
    n <- 10
    T <- 20

    for (l in lbls) {
        i <- rep(1:10, each=T)
        t <- rep(1:T, times=n)
        x <- rnorm(n*T)
        y <- rgamma(n*T, 2)
        assign(l, data.table(i, t, x, y))
        write.csv(get(l), file.path(out_dir, paste0(l,".csv")), row.names = FALSE)
    }
}