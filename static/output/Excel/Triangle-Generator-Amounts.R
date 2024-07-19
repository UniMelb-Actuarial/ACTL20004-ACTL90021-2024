library(tidyverse)
library(writexl)
library(actuar)

#################
# LRamounts1

set.seed(308231120)

dimensionI <- 9
triangle <- matrix(c(rep(0,(dimensionI+1)^2)),nrow=dimensionI+1,ncol=dimensionI+1)
rectangle <- matrix(c(rep(0,(dimensionI+1)^2)),nrow=dimensionI+1,ncol=dimensionI+1)
triangleA <- matrix(c(rep(0,(dimensionI+1)^2)),nrow=dimensionI+1,ncol=dimensionI+1)
rectangleA <- matrix(c(rep(0,(dimensionI+1)^2)),nrow=dimensionI+1,ncol=dimensionI+1)
triangleI <- matrix(c(rep(0,(dimensionI+1)^2)),nrow=dimensionI+1,ncol=dimensionI+1)
rectangleI <- matrix(c(rep(0,(dimensionI+1)^2)),nrow=dimensionI+1,ncol=dimensionI+1)
exposure <- round(runif(dimensionI+1,min=9000,max=11000),0)
claimfrequency <- c(rep(0.1,dimensionI+1))
claimcounts <- c()
iandj <- as.character(c(0:dimensionI))

WPI <- read_csv("WPI.csv", col_names = TRUE)
WPIup <- WPI$toend20[seq(1,(1+dimensionI*4),by=4)]/WPI$toend20[(1+dimensionI*4)]
WPIproject <- c(WPIup,WPIup[dimensionI+1]/(1.03)^(1:(dimensionI+1)))

notifprop <- matrix(c(rep(0,(dimensionI+1)^2)),nrow=dimensionI+1,ncol=dimensionI+1)

for (i in 1:(dimensionI+1)){
  notifprop[i,]<-discretise(pgamma(x,shape=1,rate=.6),method="rounding",from=0, to=dimensionI+1,step=1)
  claimcounts[i]<-rpois(1,exposure[i]*claimfrequency[i])
  rectangle[i,] <- rmultinom(1,claimcounts[i],notifprop[i,])
  triangle[i,1:(dimensionI-i+2)] <- rectangle[i,1:(dimensionI-i+2)]

  cumulativeclaimcounts <- cumsum(rectangle[i,])

  claimamounts <- rgamma(claimcounts[i],shape=3,rate=.01)

  rectangleA[i,1] <- round(sum(claimamounts[1:cumulativeclaimcounts[1]])/WPIproject[i],0)
  for (j in 2:(dimensionI+1)){
     rectangleA[i,j] <- round(sum(claimamounts[(cumulativeclaimcounts[j-1]+1):cumulativeclaimcounts[j]])/WPIproject[i+j-1],0) # nominal!
  }
  triangleA[i,1:(dimensionI-i+2)] <- rectangleA[i,1:(dimensionI-i+2)]


  rectangleI[i,1] <- round(sum(rectangleA[i,])*rnorm(1,1+0.1*dimensionI,.02)*cumulativeclaimcounts[1]/claimcounts[i],0)
  for (j in 2:(dimensionI)){
    rectangleI[i,j] <- round(sum(rectangleA[i,1:(j-1)])+sum(rectangleA[i,j:(dimensionI+1)])*rnorm(1,1+0.1*(dimensionI+1-j),0.02)*cumulativeclaimcounts[j]/claimcounts[i],0) # nominal!
  }
  rectangleI[i,dimensionI+1] <- sum(rectangleA[i,])
  triangleI[i,1:(dimensionI-i+2)] <- rectangleI[i,1:(dimensionI-i+2)]
}


dataset_t <- as.data.frame(cbind(exposure,triangle),row.names=iandj,colnames=iandjp)
names(dataset_t) <- c("exposure",iandj)
dataset_r <- as.data.frame(cbind(exposure,rectangle),row.names=iandj,colnames=c("exposure",iandj))
names(datasetA_r) <- iandj
datasetA_t <- as.data.frame(triangleA,row.names=iandj,colnames=iandj)
names(datasetA_t) <- iandj
datasetA_r <- as.data.frame(rectangleA)
names(datasetA_r) <- iandj
datasetI_t <- as.data.frame(triangleI,row.names=iandj,colnames=iandj)
names(datasetI_t) <- iandj
datasetI_r <- as.data.frame(rectangleI)
names(datasetI_r) <- iandj


write_xlsx(
    dataset_t,
    path = paste("LRamounts-countstriangle.xlsx",sep=""),
    col_names = TRUE
  )

write_xlsx(
  dataset_r,
  path = paste("LRamounts-countsrectangle.xlsx",sep=""),
  col_names = TRUE
)

write_xlsx(
  datasetA_t,
  path = paste("LRamounts-amountstriangle.xlsx",sep=""),
  col_names = TRUE
)

write_xlsx(
  datasetA_r,
  path = paste("LRamounts-amountsrectangle.xlsx",sep=""),
  col_names = TRUE
)

write_xlsx(
  datasetI_t,
  path = paste("LRamounts-incurredtriangle.xlsx",sep=""),
  col_names = TRUE
)

write_xlsx(
  datasetI_r,
  path = paste("LRamounts-incurredrectangle.xlsx",sep=""),
  col_names = TRUE
)


