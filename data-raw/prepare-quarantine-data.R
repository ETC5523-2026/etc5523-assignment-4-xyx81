# Import the authors' published quarantine simulation results.
# Source: https://doi.org/10.5281/zenodo.5802433
# Archive: Quarantine_ABM_2022_01_01.zip
# Original location: core_version/R0_x_VE_scan_H14_tf_1M/2021_08_26/
# Run this script from the package project root.

raw_results <- read.csv(
  "data-raw/output_t_relbase_R0xVE_scan_H14_tf_1M.csv"
)

# Inspect the dimensions, column names and first observations.
dim(raw_results)
names(raw_results)
head(raw_results)

# Check the available scenario values.
sort(unique(raw_results$R0))
sort(unique(raw_results$VE))

# Check whether any R0 and VE combination occurs more than once.
sum(duplicated(raw_results[c("R0", "VE")]))

# Count missing values in the variables needed for the main analysis.
colSums(is.na(
  raw_results[c("R0", "VE", "net_FoI_rel_base")]
))

# Inspect the baseline scenario.
subset(
  raw_results,
  R0 == 3 & VE == 0,
  select = c(R0, VE, net_FoI, net_FoI_rel_base)
)

# Retain the main-analysis outcome under the published assumptions.
# Vaccine efficacy remains a proportion between 0 and 0.9.
quarantine_scenarios <- data.frame(
  r0 = raw_results$R0,
  vaccine_efficacy = raw_results$VE,
  relative_pressure = raw_results$net_FoI_rel_base
)

# Order scenarios by transmissibility, then vaccine efficacy.
quarantine_scenarios <- quarantine_scenarios[
  order(
    quarantine_scenarios$r0,
    quarantine_scenarios$vaccine_efficacy
  ),
]

rownames(quarantine_scenarios) <- NULL

# Inspect the prepared dataset.
dim(quarantine_scenarios)
head(quarantine_scenarios)

# Save the prepared dataset for distribution with the R package.
usethis::use_data(
  quarantine_scenarios,
  overwrite = TRUE
)