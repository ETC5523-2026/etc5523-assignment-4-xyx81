# Quarantine simulation scenarios

Published simulation results describing infection pressure from border
quarantine breaches under different combinations of viral
transmissibility and vaccine efficacy.

## Usage

``` r
quarantine_scenarios
```

## Format

A data frame with 100 rows and 3 columns:

- r0:

  Basic reproduction number, ranging from 1 to 10.

- vaccine_efficacy:

  Vaccine efficacy expressed as a proportion, ranging from 0 to 0.9 in
  increments of 0.1.

- relative_pressure:

  Integrated infection pressure relative to the baseline scenario with
  r0 = 3 and vaccine efficacy = 0. A value of 1 represents the baseline
  level.

## Source

Zachreson et al. (2022), Science Advances, 8, eabm3624.
<https://doi.org/10.1126/sciadv.abm3624>

Supplementary code and data, Zenodo:
<https://doi.org/10.5281/zenodo.5802433>

## Details

Each row represents one published simulation scenario. The outcome is
relative infection pressure, not an outbreak probability. The main
analysis assumes that vaccination reduces susceptibility to infection
without reducing infectiousness in breakthrough cases. All travellers
and workers in the quarantine system are vaccinated.

These are historical model results under the study's assumptions, not
current outbreak forecasts.

The preparation script selects and renames three columns from the
authors' published results table without changing their values. The
source archive is labelled CC BY 4.0 on Zenodo.
