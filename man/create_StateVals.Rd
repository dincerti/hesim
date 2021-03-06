% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/statevals.R
\name{create_StateVals}
\alias{create_StateVals}
\alias{create_StateVals.lm}
\alias{create_StateVals.stateval_tbl}
\title{Create a \code{StateVals} object}
\usage{
create_StateVals(object, ...)

\method{create_StateVals}{lm}(
  object,
  input_data = NULL,
  n = 1000,
  uncertainty = c("normal", "none"),
  ...
)

\method{create_StateVals}{stateval_tbl}(object, hesim_data = NULL, n = 1000, ...)
}
\arguments{
\item{object}{A model object of the appropriate class.}

\item{...}{Further arguments (\code{time_reset} and \code{method}) passed to \code{\link[=StateVals]{StateVals$new()}}.}

\item{input_data}{An object of class \code{\link[=expand.hesim_data]{expanded_hesim_data}}.
Must be expanded by treatment strategies, patients, and health states.}

\item{n}{Number of random observations of the parameters to draw when parameters
are fit using a statistical model.}

\item{uncertainty}{Method determining how parameter uncertainty should be handled. See
documentation in \code{\link[=create_params]{create_params()}}.}

\item{hesim_data}{A \code{\link{hesim_data}} object. Only required when \code{object} is of class
\code{\link{stateval_tbl}}. See "details".}
}
\value{
A \code{\link{StateVals}} object.
}
\description{
\code{create_StateVals()} is a generic function for creating an object of class
\code{\link{StateVals}} from a fitted statistical model or a \code{\link{stateval_tbl}}
object.
}
\details{
If \code{object} is a \code{stateval_tbl}, then a \code{\link{hesim_data}} object is used
to specify treatment strategies, patients, and/or health states not included as
columns in the table, or, to match patients in the table to groups. Not required if
the table includes one row for each treatment strategy, patient, and health state
combination. Patients are matched to groups by specifying both a \code{patient_id}
and a \code{grp_var} column in the \code{patients} table.
}
\examples{
set.seed(10)

# EXAMPLE FOR `create_statevals.lm()`
## Simple example comparing two treatment strategies where
## medical costs vary by sex and health state

## Setup model
hesim_dat <- hesim_data(
  strategies = data.frame(strategy_id = c(1, 2)),
  patients = data.frame(
    patient_id = c(1, 2),
    female = c(1, 0)
  ),
  states = data.frame(
    state_id = c(1, 2, 3),
    state_name = c("state1", "state2", "state3")
  )
)

## Fit model
medcost_estimation_data <- psm4_exdata$costs$medical
medcost_estimation_data$time5 <- rbinom(nrow(medcost_estimation_data), 
                                        1, .5) # Illustrative time dummy
medcost_fit <- lm(costs ~ female + state_name + time5, 
                  data = medcost_estimation_data)

## Create medical cost model
### Allow medical costs to vary across time in addition to by patient and 
### health state
medcost_times <- time_intervals(
  data.frame(time_start = c(0, 3, 5),
            time5 = c(0, 0, 1)) # Time dummy corresponds to time > 5
)
medcost_input_data <- expand(hesim_dat, 
                             by = c("strategies", "patients", "states"),
                             times = medcost_times)
medcost_model <- create_StateVals(medcost_fit, medcost_input_data,
                                  n = 1)

## Explore predictions from medical cost model
### We can assess predictions at multiple time points
medcost_model$sim(t = c(1, 6), type = "predict")
}
\seealso{
See \code{\link{StateVals}} for documentation of the class and additional examples.
An example use case for \code{\link[=create_StateVals.stateval_tbl]{create_StateVals.stateval_tbl()}} is provided in
the \code{\link[=stateval_tbl]{stateval_tbl()}} documentation.
}
