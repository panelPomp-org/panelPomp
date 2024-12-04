library(dplyr)
library(tidyr)
library(tibble)
load("R/sysdata.rda")
urr = urban_rural_raw

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

ur_measles = list(
  measles = measles,
  demog = demog,
  coord = coord
)

preexisting_units = ur_measles$coord$unit[
  ur_measles$coord$unit %in% twentycities$coord$unit
]
ur_measles$coord = ur_measles$coord |>
  dplyr::bind_rows(
    dplyr::filter(twentycities$coord, !(unit %in% preexisting_units))
  )

ur_measles = lapply(ur_measles, as.data.frame)

usethis::use_data(ur_measles, overwrite = TRUE)
