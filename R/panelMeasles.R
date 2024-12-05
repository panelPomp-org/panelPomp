#' Make a panelPomp model using UK measles data
#'
#' @param units Character vector of units in [uk_measles] to be used in the
#'   panel model.
#' @param starting_pparams Parameters in the list format, having shared and
#'   specific components. Set to NULL to assign NA values.
#' @param interp_method Method used to interpolate population and births.
#'   Possible options are `"shifted_splines"` and `"linear"`.
#' @param first_year Integer for the first full year of data desired.
#' @param last_year Integer for the last full year of data desired.
#' @param dt Size of the time step.
#'
#' @return A panelPomp object.
#' @export
#'
#' @examples
#' panelMeasles(units = "London")
#'
panelMeasles = function(
    units = c("Bedwellty", "Birmingham", "Bradford", "Bristol", "Cardiff",
              "Consett", "Dalton.in.Furness", "Halesworth", "Hastings", "Hull",
              "Leeds", "Lees", "Liverpool", "London", "Manchester", "Mold",
              "Northwich", "Nottingham", "Oswestry", "Sheffield"),
    starting_pparams = NULL,
    interp_method = c("shifted_splines", "linear"),
    first_year = 1950,
    last_year = 1963,
    dt = 1/365.25
){

  ep <- wQuotes("in ''panelMeasles'': ")
  interp_method <- match.arg(interp_method)

  # Create rproc
  rproc <- pomp::Csnippet("
    double beta, br, seas, foi, dw, births;
    double rate[6], trans[6];

    // cohort effect
    if (fabs(t-floor(t)-251.0/365.0) < 0.5*dt)
      br = cohort*birthrate/dt + (1-cohort)*birthrate;
    else
      br = (1.0-cohort)*birthrate;

    // term-time seasonality
    t = (t-floor(t))*365.25;
    if ((t>=7 && t<=100) ||
        (t>=115 && t<=199) ||
        (t>=252 && t<=300) ||
        (t>=308 && t<=356))
        seas = 1.0+amplitude*0.2411/0.7589;
    else
        seas = 1.0-amplitude;

    // transmission rate
    beta = R0*seas*(1.0-exp(-(gamma+mu)*dt))/dt;

    // expected force of infection
    foi = beta*pow(I+iota,alpha)/pop;

    // white noise (extrademographic stochasticity)
    dw = rgammawn(sigmaSE,dt);

    rate[0] = foi*dw/dt;  // stochastic force of infection
    rate[1] = mu;         // natural S death
    rate[2] = sigma;      // rate of ending of latent stage
    rate[3] = mu;         // natural E death
    rate[4] = gamma;      // recovery
    rate[5] = mu;         // natural I death

    // Poisson births
    births = rpois(br*dt);

    // transitions between classes
    reulermultinom(2,S,&rate[0],dt,&trans[0]);
    reulermultinom(2,E,&rate[2],dt,&trans[2]);
    reulermultinom(2,I,&rate[4],dt,&trans[4]);

    S += births   - trans[0] - trans[1];
    E += trans[0] - trans[2] - trans[3];
    I += trans[2] - trans[4] - trans[5];
    R = pop - S - E - I;
    W += (dw - dt)/sigmaSE;  // standardized i.i.d. white noise
    C += trans[4];           // true incidence
  ")

  # Create dmeas
  dmeas <- pomp::Csnippet("
    double m = rho*C;
    double v = m*(1.0 - rho + psi*psi*m);
    double tol = 1.0e-18; // 1.0e-18 in He10 model; 0.0 is 'correct'
    if(ISNA(cases)) {lik = 1;} else {
        if (C < 0) {lik = 0;} else {
          if (cases > tol) {
            lik = pnorm(cases + 0.5, m, sqrt(v) + tol, 1, 0) -
              pnorm(cases - 0.5 , m, sqrt(v) + tol, 1, 0) + tol;
          } else {
            lik = pnorm(cases + 0.5, m, sqrt(v) + tol, 1, 0) + tol;
          }
        }
      }
    if (give_log) lik = log(lik);
  ")

  # Create rmeas
  rmeas <- pomp::Csnippet("
    double m = rho*C;
    double v = m*(1.0-rho+psi*psi*m);
    double tol = 1.0e-18; // 1.0e-18 in He10 model; 0.0 is 'correct'
    cases = rnorm(m,sqrt(v)+tol);
    if (cases > 0.0) {
      cases = nearbyint(cases);
    } else {
      cases = 0.0;
    }
  ")

  # Create rinit
  rinit <- pomp::Csnippet("
    double m = pop/(S_0+E_0+I_0+R_0);
    S = nearbyint(m*S_0);
    E = nearbyint(m*E_0);
    I = nearbyint(m*I_0);
    R = nearbyint(m*R_0);
    W = 0;
    C = 0;
  ")

  pt <- pomp::parameter_trans(
    log = c("sigma","gamma","sigmaSE","psi","R0", "mu", "alpha", "iota"),
    logit = c("cohort","amplitude", "rho"),
    barycentric = c("S_0","E_0","I_0","R_0")
  )

  paramnames = c("R0","mu","sigma","gamma","alpha","iota", "rho",
                 "sigmaSE","psi","cohort","amplitude",
                 "S_0","E_0","I_0","R_0")
  states = c("S", "E", "I", "R", "W", "C")

  choose_units <- function(data, units){
    out <- lapply(seq_along(data), function(z){
      data[[z]][data[[z]]$unit %in% units,]
    })
    names(out) <- names(data)
    out
  }
  data <- choose_units(panelPomp::uk_measles, units)
  measles <- data$measles
  demog <- data$demog

  ## Prep Data
  units <- unique(measles$unit)
  # Obs list
  dat_list <- vector("list", length(units))
  # Population list
  demog_list <- vector("list", length(units))
  for(i in seq_along(units)){
    me <- measles
    me$year <- as.integer(format(me$date,"%Y"))
    me <- subset(
      me,
      me$unit == units[[i]] &
      me$year >= first_year &
      me$year < (last_year + 1)
    )
    me$time = time = julian(
      me$date,
      origin = as.Date(paste0(first_year, "-01-01"))
    )/365.25 + first_year
    me <- subset(
      me,
      me$year >= first_year &
      me$year < (last_year + 1),
      select = c("time", "cases")
    )
    dat_list[[i]] <- me

    demog_list[[i]] <- subset(demog, demog$unit == units[[i]])
    demog_list[[i]] <- demog_list[[i]][c("year", "pop", "births")]
  }

  ## Prep Covariates
  delay <- 4 # number of years before a newborn can be infected
  covar_list <- vector("list", length(units))

  for(i in seq_along(units)){
    dmgi <- demog_list[[i]]
    times <- seq(from = min(dmgi$year), to = max(dmgi$year), by = 1/12)
    switch(interp_method,
       shifted_splines = {
         pop_interp = stats::predict(
           stats::smooth.spline(x = dmgi$year, y = dmgi$pop),
           x = times
         )$y
         births_interp = stats::predict(
           stats::smooth.spline(x = dmgi$year + 0.5, y = dmgi$births),
           x = times - delay
         )$y
       },
       linear = {
         pop_interp = stats::approx(
           x = dmgi$year,
           y = dmgi$pop,
           xout = times
         )$y
         births_interp = stats::approx(
           x = dmgi$year,
           y = dmgi$births,
           xout = times - delay
         )$y
       }
    )
    covar_list[[i]] <- data.frame(
      time = times,
      pop = pop_interp,
      birthrate = births_interp
    )
  }

  ## Pomp Construction
  lapply(seq_along(units), function(i){
    time <- covar_list[[i]]$time
    dat_list[[i]] |>
      pomp::pomp(
        t0 = with(dat_list[[i]], 2*time[1] - time[2]),
        times = "time",
        rprocess = pomp::euler(rproc, delta.t = dt),
        rinit = rinit,
        dmeasure = dmeas,
        rmeasure = rmeas,
        covar = pomp::covariate_table(covar_list[[i]], times = "time"),
        accumvars = c("C","W"),
        partrans = pt,
        statenames = states,
        paramnames = paramnames
      )
  }) -> pomp_list
  names(pomp_list) <- units

  ## panelPomp construction
  if(is.null(starting_pparams)){
    # AK_pparams comes from R/sysdata.rda
    shared <- AK_pparams$shared
    specific <- AK_pparams$specific[, names(pomp_list)]
  } else {
    shared <- starting_pparams$shared
    specific <- as.matrix(starting_pparams$specific)
    if(!setequal(c(names(shared), rownames(specific)), paramnames)){
      stop(ep,"Parameter names in starting_pparams do not match those in model.",call.=FALSE)
    }
  }
  panelPomp::panelPomp(
    pomp_list,
    shared = shared,
    specific = specific
  )
}
