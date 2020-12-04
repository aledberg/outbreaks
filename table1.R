########################################################
require(data.table)
#######################################################

## Run this from main.R or load the data 
## mort <- readRDS("mortality_data_1860_2020.rds")

pmort <- mort

##################################################################3
## load population and outbreak data

source("totalPopulation.R")

## need to translate these dates into a set of indices

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
 
## number of years in the past to include, start from the date of the outbreak
nback <- 5
odata <- data.frame()
for (i in 1:dim(outb)[1]){
    ##for (i in 1:8){
    ## start and stop dates for the current outbreak
    sto <- outb$onset[i]
    sta <- sto-nback*365.25
    
    tdat <- cdat[date > sta & date < sto]
    realdat <- pmort[date > sta & date < outb$offset[i]]

    tdat$time <- tdat$time-min(tdat$time)
    realdat$time <- realdat$time-min(realdat$time)
    ## model this
    fit <- glm(N~1+poly(time,1)+as.factor(dmonth),data=tdat,family=poisson)

    
    pre <- predict(fit,newdata=realdat,type="response")
    ## uncomment to plot 
    ##plot(realdat$date,realdat$N)
    ##lines(realdat$date,pre,col="red")
    
    indx <- realdat$date >= outb$onset[i] & realdat$date <= outb$offset[i]
    print(paste("from:", outb$onset[i], "; to:", outb$offset[i], "; excess mort:", sum(realdat$N[indx]-pre[indx])))
    odata <- rbind(odata,data.frame(from=outb$onset[i],to=outb$offset[i],expected=sum(pre[indx]),observed=sum(realdat$N[indx]),outbreak=i,dur=as.integer(outb$offset[i]-outb$onset[i]),pop=outb$population[i]))
}

odata$excess <- ((odata$observed-odata$expected))
odata$relexcess <- ((odata$observed-odata$expected)/odata$po)


odata <- data.table(odata)
## write an csv version of the I can incorporate into the ms
## data set to save
sdat <- odata
sdat <- sdat[,c("expected","observed","pop"):=NULL]
## format dates according to English standard
Sys.setlocale("LC_TIME","C")
output <- data.frame()
output <- data.frame(from=format(sdat$from,"%b %d %Y"),to=format(sdat$to,"%b %d %Y"),dur=sdat$dur,excess=round(sdat$excess),rexcess=format(1.0e5*sdat$relexcess,digits=3))

print(output)
## write.table(output,"dataforTable1.csv",row.names=FALSE,sep=",")
