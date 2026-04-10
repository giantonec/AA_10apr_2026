clear all
set more off

local root "C:/Users/u0159745/OneDrive - Università degli Studi di Milano-Bicocca/Bicocca/learning/AA_10apr_2026"
import delimited "`root'/data/us_output_gap_1990_2020_quarterly.csv", clear varnames(1)

gen obs_date = date(date, "YMD")
format obs_date %td

gen quarter = qofd(obs_date)
format quarter %tq
tsset quarter

twoway ///
    (line output_gap_percent quarter, lcolor(navy) lwidth(medthick)), ///
    yline(0, lcolor(maroon) lpattern(dash)) ///
    xtitle("Quarter") ///
    ytitle("Output gap (%)") ///
    title("US Output Gap, 1990-2020") ///
    note("Source: FRED series GDPC1 and GDPPOT; output gap = (real GDP / potential GDP - 1) * 100")

graph export "`root'/data/us_output_gap_1990_2020_quarterly.png", replace width(2000)
save "`root'/data/us_output_gap_1990_2020_quarterly.dta", replace
