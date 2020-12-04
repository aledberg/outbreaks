########################################################
require(ggplot2)
require(data.table)
#######################################################

## Run this from main.R or load the data 
## mort <- readRDS("mortality_data_1860_2020.rds")

pmort <- mort

## load outbreak data
outb <- read.table("outbreaks.csv",header=TRUE,sep=',')
outb$onset <- as.Date(outb$onset)
outb$offset <- as.Date(outb$offset)


outbAll <- list()
for (i in 1:dim(outb)[1]){
    indx <- which(pmort$date >=outb$onset[i] & pmort$date <= outb$offset[i])
    outbAll <- append(outbAll,indx)
}
outbAll <- unlist(outbAll)


########################################################
## create a data set where all the outbreaks have been removed
cdat <- pmort
cdat <- cdat[!outbAll]

nback <- 5
i <- dim(outb)[1]

sto <- outb$onset[i]
sta <- sto-nback*365.25

tdat <- cdat[date > sta & date < sto]
realdat <- pmort[date > sta & date < outb$offset[i]]

tdat$time <- tdat$time-min(tdat$time)
realdat$time <- realdat$time-min(realdat$time)
## model this
fit <- glm(N~1+poly(time,1)+as.factor(dmonth),data=tdat,family=poisson)

## use model to predict
pre <- predict(fit,newdata=realdat,type="response")

## make a data frame for plotting
plotdat <- realdat
plotdat$type <- "real data"
plotdat <- rbind(plotdat,data.frame(date=realdat$date,N=pre,dmonth=realdat$dmonth,time=realdat$time,type="prediction"))
indx <- realdat$date >= outb$onset[i] & realdat$date <= outb$offset[i]
obdat <- realdat[indx]
obdat$type="outbreak"
plotdat <- rbind(plotdat,obdat)
plotdat <- rbind(plotdat,obdat)

## define sizes of things
## point size
psize <- 1
## line size
lsize <- 1
## text size for axis labels 
atextsize <- 14
## text size for axis title
textsize <- 14
## text size for annotations
tsize <- 5
## textsize for inset in figure 1
itextsize <- 10

psize <- 0.6
pl <- ggplot(data=plotdat[type=="prediction"],aes(x=date,y=N))+geom_point(data=plotdat[type=="real data"],color="gray",size=psize)+geom_line()+theme_bw()+ylab("#deaths/day")+xlab("date of death")+theme(axis.text=element_text(size=atextsize),axis.title=element_text(size=textsize),legend.text=element_text(size=textsize))+geom_point(data=plotdat[type=="outbreak"],color="red",size=psize)


plot(pl)
