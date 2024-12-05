#' Weekly reported measles data for 355 locations in the UK
#'
#' @format ## `uk_measles`
#' A list of 3 data frames Unit names ending in `.RD` are for rural areas; other
#' unit names are for urban areas. NOTE: not all units have coordinates.
#'
#' ## `uk_measles$measles`:
#' \describe{
#'   \item{unit}{City name}
#'   \item{data}{Date of observation}
#'   \item{cases}{Number of measles cases reported during the week}
#' }
#' ## `uk_measles$demog`:
#' \describe{
#'   \item{unit}{City name}
#'   \item{year}{Year that demography was recorded}
#'   \item{pop}{Population}
#'   \item{births}{Births}
#' }
#' ## `uk_measles$coord`:
#' \describe{
#'   \item{unit}{City name}
#'   \item{long}{Longitude of city}
#'   \item{lat}{Latitude of city}
#' }
#'
#' @references
#' \Korevaar2020
#' @source <https://rs.figshare.com/collections/Supplementary_material_from_Structure_space_and_size_competing_drivers_of_variation_in_urban_and_rural_measles_transmission_/5036567/1>
"uk_measles"
