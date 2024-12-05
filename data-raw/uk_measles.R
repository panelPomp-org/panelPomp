library(dplyr)
library(tidyr)
library(tibble)

#### Code used to move the urban_rural_raw into the data-raw folder:
# load("R/sysdata.rda")  # Done while the urban_rural_raw is part of this data
# saveRDS(urban_rural_raw, 'data-raw/urban_rural_raw.rds')
#
#
#### Also used to remove the urban_rural_raw from sysdata
# load("R/sysdata.rda")
# usethis::use_data(AK_pparams, internal = TRUE, overwrite = TRUE)

urr = readRDS('data-raw/urban_rural_raw.rds')
load('data/twentycities.rda')  # TODO: Can we document where this came from?

dates = as.Date("1944-01-07") + 7*(0:(nrow(urr$measles_urban) - 1))

measles = cbind(urr$measles_rural, urr$measles_urban)
colnames(measles) = make.names(names = colnames(measles), unique = TRUE)
measles = measles |>
  mutate(date = dates) |>
  pivot_longer(-date, names_to = "unit", values_to = "cases") |>
  select(unit, everything()) |>
  arrange(unit)

demog_pop = cbind(urr$pop_rural, urr$pop_urban)
colnames(demog_pop) = make.names(names = colnames(demog_pop), unique = TRUE)
demog_pop = demog_pop |>
  rownames_to_column(var = "year") |>
  mutate(year = as.integer(year) + 1900) |>
  pivot_longer(-year, names_to = "unit", values_to = "pop")

demog_births = cbind(urr$births_rural, urr$births_urban)
colnames(demog_births) = make.names(names = colnames(demog_births), unique = TRUE)
demog_births = demog_births |>
  rownames_to_column(var = "year") |>
  mutate(year = as.integer(year) + 1900) |>
  pivot_longer(-year, names_to = "unit", values_to = "births")

demog = full_join(demog_pop, demog_births, by = c("unit", "year")) |>
  select(unit, everything())

coord = rbind(urr$coord_rural, urr$coord_urban) |>
  rename(unit = "X", long = "Long", lat = "Lat") |>
  as_tibble()

sub_units <- demog |>
  group_by(unit) |>
  summarize(mean_pop = mean(pop)) |>
  slice_max(prop = 0.25, order_by = mean_pop) |>  # Get the top 25% of locations, by average population
  pull(unit)

uk_measles = list(
  measles = measles |> filter(unit %in% sub_units),
  demog = demog |> filter(unit %in% sub_units),
  coord = coord |> filter(unit %in% sub_units)
)

preexisting_units = uk_measles$coord$unit[
  uk_measles$coord$unit %in% twentycities$coord$unit
]
uk_measles$coord = uk_measles$coord |>
  dplyr::bind_rows(
    dplyr::filter(twentycities$coord, !(unit %in% preexisting_units))
  )

uk_measles = lapply(uk_measles, as.data.frame)

usethis::use_data(uk_measles, overwrite = TRUE)
