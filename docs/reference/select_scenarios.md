# Select quarantine simulation scenarios

Selects scenarios for specified reproduction numbers and a minimum
vaccine efficacy. Results are ordered by reproduction number and vaccine
efficacy.

## Usage

``` r
select_scenarios(data, r0_values = 1:10, min_efficacy = 0)
```

## Arguments

- data:

  A data frame containing the numeric columns \`r0\`,
  \`vaccine_efficacy\` and \`relative_pressure\`.

- r0_values:

  A numeric vector of reproduction numbers to retain. Defaults to all
  published values from 1 to 10.

- min_efficacy:

  A single number between 0 and 0.9. Scenarios with vaccine efficacy
  equal to or above this value are retained. Defaults to 0.

## Value

A data frame containing the selected scenarios. Returns zero rows when
no scenarios match.

## Examples

``` r
select_scenarios(
  quarantine_scenarios,
  r0_values = c(3, 6),
  min_efficacy = 0.5
)
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
