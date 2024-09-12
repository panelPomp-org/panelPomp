<meta charset="UTF-8">

## **panelPomp**

### an *R* package for inference on panel partially observed Markov processes

[![Project Status: Active -- The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active) [![CRAN Status](https://www.r-pkg.org/badges/version/panelPomp)](https://cran.r-project.org/package=panelPomp) [![Last CRAN release date](https://www.r-pkg.org/badges/last-release/panelPomp)](https://cran.r-project.org/package=panelPomp) [![R-CMD-check](https://github.com/panelPomp-org/panelPomp/actions/workflows/r-cmd-check.yml/badge.svg)](https://github.com/panelPomp-org/panelPomp/actions/workflows/r-cmd-check.yml) [![binary-build](https://github.com/panelPomp-org/panelPomp/actions/workflows/binary-build.yml/badge.svg)](https://github.com/panelPomp-org/panelPomp/actions/workflows/binary-build.yml) [![test-coverage](https://github.com/panelPomp-org/panelPomp/actions/workflows/test-coverage.yml/badge.svg)](https://github.com/panelPomp-org/panelPomp/actions/workflows/test-coverage.yml)[![codecov](https://codecov.io/gh/panelPomp-org/panelPomp/graph/badge.svg?token=NI3KX6NIUN)](https://codecov.io/gh/panelPomp-org/panelPomp)

This package allows performing data analysis based on panel partially-observed Markov process (PanelPOMP) models. To implement such models, simulate them and fit them to panel data, 'panelPomp' extends some of the facilities provided for time series data by the 'pomp' package. Implemented methods include filtering (panel particle filtering) and maximum likelihood estimation (Panel Iterated Filtering) as proposed in Bretó, Ionides and King (2020) "Panel Data Analysis via Mechanistic Models" [\<doi:10.1080/01621459.2019.1604367\>](https://doi.org/10.1080/01621459.2019.1604367).

The latest version of the package can be installed from this GitHub source using `devtools::install_github('panelPomp-org/panelPomp')`

Installing the current CRAN version is also possible using `install.packages("panelPomp")`

Related packages:

-   [**pomp**](https://github.com/kingaa/pomp/)
-   [**spatPomp**](https://github.com/kidusasfaw/spatPomp)
-   [**phylopomp**](https://github.com/kingaa/phylopomp/)
