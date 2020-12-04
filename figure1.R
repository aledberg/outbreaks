######################################################################
require(ggplot2)
require(gridExtra)
##############################################################################

## Run this from main.R or load the data 
## mort <- readRDS("mortality_data_1860_2020.rds")

pmort  <- mort
outb <- read.table("outbreaks.csv",header=TRUE,sep=',')
outb$onset <- as.Date(outb$onset)
outb$offset <- as.Date(outb$offset)
## need to translate these dates into a set of indices

outbAll <- list()
for (i in 1:dim(outb)[1]){
    indx <- which(pmort$date >=outb$onset[i] & pmort$date <= outb$offset[i])
    outbAll <- append(outbAll,indx)
}
outbAll <- unlist(outbAll)

## create a data set for plotting
## we divide the 160 years into 30 year slizes
tslize <- list()

tslize[[1]] <- c("1860-01-01","1900-08-31")
tslize[[2]] <- c("1900-01-01","1930-08-31")
tslize[[3]] <- c("1930-01-01","1960-08-31")
tslize[[4]] <- c("1960-01-01","1990-08-31")
tslize[[5]] <- c("1990-01-01","2020-08-31")

## need to make a small data set that shows the break of the data sets
breakDate <- "2015-01-01"
breakdata <- data.frame(date=as.Date(breakDate)-1,N=0)
breakdata <- rbind(breakdata,data.frame(date=as.Date(breakDate),N=600))

sig <- 1
klen <- 7
gker <- dnorm(seq(-3,3,length.out=klen),0,sig)
gker <- gker/sum(gker)
textsize <- 10
atextsize <- 10
##pmort$fdat <- filter(pmort$N,gker)
pmort$fdat <- filter(pmort$N,rep(1,7)/7)
##pmort$fdat <- pmort$N
psize <- 0.01
ymin <- 100
##ymax <- 655
ymax <- 420
plist <- list()
for (i in 1:length(tslize)){    
    indx <- pmort$date >= tslize[[i]][1] & pmort$date <= tslize[[i]][2]
    windx <- which(indx)
    tmpd <- pmort[indx,]
    ## find the indices of the outbreaks
    oindx <- outbAll %in% windx
    oindx <- outbAll[which(oindx)]
    otmpd <- pmort[oindx,]
    if (i!=5){
        plist[[i]] <- ggplot(data=tmpd,aes(x=date,y=fdat))+geom_point(size=psize)+theme_bw()+geom_point(data=otmpd,aes(x=date,y=fdat),color="red",size=0.2)+ylim(c(ymin,ymax))+ylab("#death/day")+xlab("date of death")+theme(legend.title=element_blank(),legend.position="none",axis.text=element_text(size=atextsize),axis.title=element_text(size=textsize),legend.text=element_text(size=textsize),axis.title.x=element_blank())
    }else{
        plist[[i]] <- ggplot(data=tmpd,aes(x=date,y=fdat))+geom_point(size=0.1)+theme_bw()+geom_point(data=otmpd,aes(x=date,y=fdat),color="red",size=0.2)+ylim(c(ymin,ymax))+ylab("#death/day")+xlab("date of death")+theme(legend.title=element_blank(),legend.position="none",axis.text=element_text(size=atextsize),axis.title=element_text(size=textsize),legend.text=element_text(size=textsize))+xlim(c(as.Date(tslize[[5]][1]),as.Date(tslize[[5]][2])))+geom_vline(xintercept=as.Date(breakDate))
    }
}
pg <- grid.arrange(plist[[1]],plist[[2]],plist[[3]],plist[[4]],plist[[5]],nrow=5)
