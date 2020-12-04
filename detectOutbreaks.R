## Script for running the outbreak-detection algorithm described in:
## Ledberg (2020) Mortality of the COVID-19 outbreak in Sweden in relation to previous severe disease outbreaks
## 
##
## A. Ledberg, 2020-12-04


require(data.table)

## load data
fn="mortality_data_1860_2020.rds"
mort <- readRDS(fn)

## source the algorithm
source("detect.R")
thresh <- 2.9
outbreaks <- detectOutbreak(mort,thresh)

## the output is a list of lists of indices defining the outbreaks.
## note that the offsets of the outbreaks in the manuscripts sometimes
## were edited manually since the automatically detected offsets sometimes
## were a bit off 
## to plot the complete data concatenate the list

outb <- list()
for (i in 1:length(outbreaks)){
    outb <- append(outb,outbreaks[[i]])
}
outb <- unlist(outb)
plot(mort$date,mort$N)
lines(mort$date[outb],mort$N[outb],col="red",type='p')


## more useful perhaps is to plot data from a specific outbreak
## assume there are at least 4 outbreaks
num <- 18

indx <- outbreaks[[num]]

## plot also some data before and after the outbreak
pad <- 365 ## for 1 year

indx2 <- seq(min(indx)-pad,max(indx)+pad)

plot(mort$date[indx2],mort$N[indx2])
lines(mort$date[indx],mort$N[indx],col="red",type='p')

