## routine that detects possible outbreaks in mortality data given a time series of
## of death coutns as input.

## A. Ledberg, 2020-12-04

## mort is a time series of mortality data in counts per day. Assume two columns,
## date that contains the day and N that is the count of dead
detectOutbreak <- function(mort,thresh=4,sizethresh=10,verbose=0){

    if ((! "N" %in% colnames(mort)) | (! "date" %in% colnames(mort)) ){
        print("Error: please name the variables date and N")
        return(0)
    }
    ## first thing we smooth the data with a trucated gaussian
    ## these parameters have been found by trial and error but
    ## can be changed 
    sig <- 1.5
    klen <- 21
    gker <- dnorm(seq(-3,3,length.out=klen),0,sig)
    gker <- gker/sum(gker)
    fdat <- filter(mort$N,gker)

    ## then approximate the derivative by first order difference
    deriv <- diff(fdat)
    ## cluster this data and remove clusters that are too small
    source("clust1D.R")
    clu <- clust1Dfast(deriv,thresh)
    clust <- clu[[1]]
    ## get sizes of clusters
    csize <- unlist(clu[[2]])
    ## and keep only outbreaks where the derivative is above threshold more than
    ## sizethresh days in a row
    clustindx <- which(csize >sizethresh)


    ## now we go through each detected outbreak and find the starting point and ending point
    outb <- list()
    for (i in 1:length(clustindx)){
        ##print(paste("cluster: ", i))
        clunr <- clustindx[i]

        ## the starting point of the outbreak is taken as the point where the
        ## derivative first exceeded the threshold
        mi <- min(clust[[clunr]])
        sta <- mi

        ## define the end of the cluster as the point after the derivatve has passed
        ## it's negative inflection point where this value is getting back to zero

        ## assume that the min of the derivative happens in 180 days
        nstep=min(length(fdat)-sta,180)
        if (verbose!=0)
            print(paste("nstep:", nstep))
        ## find the lowest point of the derivative 
        gradmin <- which(deriv[sta:(sta+nstep)]==min(deriv[sta:(sta+nstep)],na.rm=1))+sta
        ## and check where it comes back to zero
        if ( (nstep+gradmin) <= length(deriv)){
            thindx <- min(which(deriv[gradmin:(gradmin+nstep)]> 0),na.rm=1)
        }else{
            thindx <- min(which(deriv[gradmin:length(deriv)]> 0),na.rm=1)
        }

        if ( (length(thindx) > 0) & is.finite(thindx)){
            indx <- min(thindx)
        }else{ ## get here iff the excursion exists until the end of fdat
            indx <- nstep+1
        }
        if (verbose!=0)
            print(indx)
        if ((length(thindx) > 0) & is.finite(thindx)){
            sto <- gradmin+indx-1
        }else{ ## get here iff the excursion exists until the end of fdat
            sto <- sta+nstep
        }
        if (verbose!=0)
            print(paste("sta:", sta, " sto:", sto))
        outb[[i]] <- sta:sto
    }
    return(outb)
}
