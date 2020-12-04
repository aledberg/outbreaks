## function to detect all connected regions above a threshold
## Anders Ledberg 2020 12 04
clust1Dfast <- function(data,thresh,verbose=0){
    tdat <- as.integer(data > thresh)
    tdatdiff <- diff(tdat)
    ## tdatdiff is 1 when there was an upcrossing
    upcross <- which(tdatdiff==1)
    downcross <- which(tdatdiff==-1)
    if (length(upcross)<=1){
        print("Error: too few upcrosses detected, maybe do this manually instead")
        return(NA)
    }
    if (length(downcross)<=1){
        print("Error: to few downcrosses detected, maybe do this manually instead")
        return(NA)
    }

    ## check if the first event was an uppcrossing
    ## keep the indices of the clusters
    clust <- list()

    ## get four cases depending on if we start in a excursion and or end in one
    if (upcross[1] < downcross[1]){ ## here we start below
        if (length(downcross)<length(upcross)){ ## this means that we end in an excursion
            clen <- downcross-upcross[1:length(downcross)]
            clen <- append(clen,length(tdat)-upcross[length(upcross)])
        }else{
            clen <- downcross-upcross
        }
    }else{ ## here we start in an excursion
        if (length(downcross)==length(upcross)){ ## this means that we end in an excursion
            clen <- downcross[1]
            clen <- append(clen,downcross[2:length(downcross)]-upcross[1:(length(downcross)-1)])
            clen <- append(clen,length(tdat)-upcross[length(upcross)])
        }else{ ## end below 
            clen <- downcross[1]
            clen <- append(clen,downcross[2:length(downcross)]-upcross[1:(length(downcross)-1)])
        }
    }
    clust <- list()
    for (i in 1:length(clen)){ ## make sure that you finsih coding here
        if (upcross[1] < downcross[1]){ ## here we start below 
            clust[[i]] <- seq(upcross[i]+1,upcross[i]+clen[i])
        }else{ ## start in an excursion
            if (i==1){
                clust[[i]] <- seq(1,clen[i])
            }else{
                clust[[i]] <- seq(upcross[i-1]+1,upcross[i-1]+clen[i])
            }
        }
    }
    out <- list()
    out[[1]] <- clust
    out[[2]] <- clen
    return(out)
}
