## script to read the population data. these data are from SCB and refers to the population the last
## of december a given year

library(data.table)
library(tidyr)
library(plyr)
library(survival)
require(splines)

fn <- "befolkning_1860_2019.csv"

pop <- read.table(fn,sep=",",header=TRUE,encoding='latin1',quote="",stringsAsFactor=FALSE)
pop <- data.table(pop)

mpop <- melt(pop,id.vars=c("ålder","kön"))
names(mpop) <- c("age","sex","year","N")
mpop <- mpop[order(year)]

## remove the ugly X in the beginning of the years
ynames <- c(1860:2019)
levels(mpop$year) <- ynames

## make averages for all ages and sex
totpop <- mpop[,.(population=sum(N)),by=year]
totpop$date <- as.Date(paste(totpop$year,"-12-31",sep=""))


## extract the population size at the time of the outbreaks
##outb <- read.table("outbreaks_covid.csv",header=TRUE,sep=',')
outb <- read.table("outbreaks.csv",header=TRUE,sep=',')
outb$onset <- as.Date(outb$onset)
outb$offset <- as.Date(outb$offset)

outb$population <- 0

for (i in 1:dim(outb)[1]){
    indx <- max(which(totpop$date < outb$onset[i]))
    outb$population[i] <- totpop$population[indx]
}
