# Using the quarantine scenario explorer

## Purpose

This app helps public health students explore the question: how does
relative infection pressure from quarantine breaches change with viral
transmissibility and vaccine efficacy?

It uses published simulation scenarios from Zachreson et al. (2022).

## Install and launch

Install from GitHub. Access is required if the repository is private.

``` r

install.packages("devtools")
devtools::install_github("ETC5523-2026/etc5523-assignment-4-xyx81")
```

Load the package:

``` r

library(dataexplorer)
```

Launch the interactive app from the R console:

``` r

run_app()
```

## Use the controls

1.  Select one or more R0 values using the checkboxes. Higher R0
    represents greater viral transmissibility.
2.  Move the slider to set the minimum vaccine efficacy. The minimum is
    included: choosing 70% retains the simulated values 70%, 80% and
    90%.
3.  Compare the plot, summary and table, which update together.
4.  If no R0 values are selected, the app displays a message asking you
    to select at least one value.

The app reads the dataset included in the installed package. It does not
require a separate CSV file at runtime.

## Work with scenarios in R

The exported function
[`select_scenarios()`](../reference/select_scenarios.md) performs the
same filtering used by the app.

``` r

selected <- select_scenarios(
  data = quarantine_scenarios,
  r0_values = c(3, 6),
  min_efficacy = 0.5
)

selected
#>    r0 vaccine_efficacy relative_pressure
#> 1   3              0.5        0.29183561
#> 2   3              0.6        0.22369157
#> 3   3              0.7        0.12244568
#> 4   3              0.8        0.10566475
#> 5   3              0.9        0.03570799
#> 6   6              0.5        1.00990948
#> 7   6              0.6        0.74000431
#> 8   6              0.7        0.29838987
#> 9   6              0.8        0.24983511
#> 10  6              0.9        0.08162687
```

This selection returns 10 scenarios. Vaccine efficacy is stored as a
proportion in the data and displayed as a percentage in the app.

## Interpret a comparison

At 50% vaccine efficacy, compare R0 values of 3 and 6:

``` r

selected[selected$vaccine_efficacy == 0.5, ]
#>   r0 vaccine_efficacy relative_pressure
#> 1  3              0.5         0.2918356
#> 6  6              0.5         1.0099095
```

Relative infection pressure is approximately 0.292 for R0 = 3 and 1.010
for R0 = 6. Under these model assumptions, the higher transmissibility
scenario has greater infection pressure at the same vaccine efficacy.

The dashed reference line at 1 represents the fixed baseline: R0 = 3 and
vaccine efficacy = 0%. A value of 0.5 means half the baseline pressure;
a value of 2 means twice the baseline pressure.

## Assumptions and limitations

These are historical simulation results, not observed outbreak
probabilities or forecasts for current conditions.

The selected analysis assumes that all quarantine travellers and workers
are vaccinated. Vaccine efficacy reduces susceptibility to infection
without reducing infectiousness in breakthrough cases. It does not
represent community vaccination coverage.

Points show published scenarios. Connecting lines guide comparison and
do not estimate results between simulated scenarios.

## Sources

- [Zachreson et al. (2022),
  article](https://doi.org/10.1126/sciadv.abm3624)
- [Supplementary code and data (2021),
  Zenodo](https://doi.org/10.5281/zenodo.5802433)

The source data archive is licensed under CC BY 4.0. Data preparation
selects and renames three columns without changing their values.
