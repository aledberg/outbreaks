## Top-level script for generating the figures and table corrssponding to
## Ledberg (2020) Mortality of the COVID-19 outbreak in Sweden in relation to previous severe disease outbreaks
## 
##
## A. Ledberg, 2020-12-04


## This code in this file load the mortality data and calls scripts to do the plotting
## and tabulation

## needs ggplot and data.table
require(ggplot2)
require(data.table)


######################################################################
## load the data
fn="mortality_data_1860_2020.rds"
mort <- readRDS(fn)

#####################################################################
## Make the figures. 

## figure 1
source("figure1.R")

## figure 2
source("figure2.R")

## table 1
source("table1.R")
