clear all
set more off
capture log close
log using "dofiles/plot_output_gap_run.log", replace text

*** Use the current working directory as the project root to avoid path-encoding issues.
local root "."
*** Import the quarterly output-gap CSV with variable names from the first row.
import delimited "`root'/data/us_output_gap_1990_2020_quarterly.csv", clear varnames(1)
rename real_gdp_b* real_gdp
rename potential_gdp* potential_gdp
rename output_gap_p* output_gap_percent

*** Convert the string date into a Stata daily date and format it for readability.
gen obs_date = date(date, "YMD")
format obs_date %td

*** Transform the daily date into a quarterly time index for time-series plotting.
gen quarter = qofd(obs_date)
format quarter %tq
order quarter obs_date
sort quarter
tsset quarter

*** Keep the output-gap variables needed for later merging and save an intermediate Stata file.
keep quarter obs_date output_gap_percent real_gdp potential_gdp
save "`root'/data/us_output_gap_1990_2020_quarterly.dta", replace

*** Plot the output gap over time and add a zero line as a reference benchmark.
twoway ///
    (line output_gap_percent quarter, lcolor(navy) lwidth(medthick)), ///
    yline(0, lcolor(maroon) lpattern(dash)) ///
    xtitle("Quarter") ///
    ytitle("Output gap (%)") ///
    title("US Output Gap, 1990-2020") ///
    note("Source: FRED series GDPC1 and GDPPOT; output gap = (real GDP / potential GDP - 1) * 100")

*** Export the graph to the results folder with high resolution.
graph export "`root'/output/results/us_output_gap_1990_2020_quarterly.png", replace width(2000)

*** Import the monthly CPI series downloaded from FRED.
import delimited "`root'/data/us_cpi_monthly.csv", clear varnames(1)

*** Convert the monthly string date into Stata dates and keep the sample used in the project.
gen month_date = date(observation_date, "YMD")
format month_date %td
keep if inrange(month_date, date("1990-01-01", "YMD"), date("2020-12-31", "YMD"))

*** Build a quarterly date, average CPI within each quarter, and declare the data as quarterly.
gen quarter = qofd(month_date)
format quarter %tq
collapse (mean) cpi_level = cpiaucsl, by(quarter)
sort quarter
tsset quarter

*** Compute year-over-year CPI inflation so it matches the quarterly output-gap frequency.
gen inflation_percent = 100 * ((cpi_level / L4.cpi_level) - 1)
drop if missing(inflation_percent)

*** Save the quarterly inflation series in both Stata and CSV formats.
save "`root'/data/us_cpi_inflation_quarterly_1990_2020.dta", replace
export delimited using "`root'/data/us_cpi_inflation_quarterly_1990_2020.csv", replace

*** Merge the quarterly inflation series with the output-gap series using the quarter identifier.
merge 1:1 quarter using "`root'/data/us_output_gap_1990_2020_quarterly.dta", nogen keep(match)
order quarter obs_date output_gap_percent inflation_percent
sort quarter

*** Save the merged Phillips-curve style dataset for later use.
save "`root'/data/us_output_gap_cpi_inflation_1990_2020.dta", replace
export delimited using "`root'/data/us_output_gap_cpi_inflation_1990_2020.csv", replace

*** Create a scatterplot with output gap on the x-axis and inflation on the y-axis.
twoway ///
    (scatter inflation_percent output_gap_percent, mcolor(navy%55) msymbol(O)) ///
    (lfit inflation_percent output_gap_percent, lcolor(maroon) lwidth(medthick)), ///
    xtitle("Output gap (%)") ///
    ytitle("CPI inflation (%; year-over-year, quarterly average)") ///
    title("US Inflation and the Output Gap, 1990-2020") ///
    note("Inflation uses CPIAUCSL from FRED aggregated to quarterly averages; fitted line shown for reference")

*** Export the scatterplot to the results folder.
graph export "`root'/output/results/us_output_gap_cpi_inflation_scatter_1990_2020.png", replace width(2000)
capture log close
