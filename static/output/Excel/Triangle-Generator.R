library(tidyverse)
library(writexl)
library(actuar)

#################
# LRcounts1

set.seed(308231120)

dimensionI <- 15
triangle <- matrix(c(rep(0,(dimensionI+1)^2)),nrow=dimensionI+1,ncol=dimensionI+1)
rectangle <- matrix(c(rep(0,(dimensionI+1)^2)),nrow=dimensionI+1,ncol=dimensionI+1)
exposure <- round(runif(dimensionI+1,min=1800,max=2200),0)
claimfrequency <- c(rep(0.1,dimensionI+1))

notifprop <- matrix(c(rep(0,(dimensionI+1)^2)),nrow=dimensionI+1,ncol=dimensionI+1)

for (i in 1:(dimensionI+1)){
  notifprop[i,]<-discretise(pgamma(x,3),method="rounding",from=0, to=dimensionI+1,step=1)
  rectangle[i,] <- rmultinom(1,rpois(1,exposure[i]*claimfrequency[i]),notifprop[i,])
  triangle[i,1:(dimensionI-i+2)] <- rectangle[i,1:(dimensionI-i+2)]
}

dataset_t <- as.data.frame(cbind(exposure,triangle))
dataset_r <- as.data.frame(cbind(exposure,rectangle))

write_xlsx(
    dataset_t,
    path = paste("LRcounts1-triangle.xlsx",sep=""),
    col_names = FALSE,
    format_headers=FALSE
  )

write_xlsx(
  dataset_r,
  path = paste("LRcounts1-rectangle.xlsx",sep=""),
  col_names = FALSE,
  format_headers=FALSE
)


#################
# LRcounts2

set.seed(308231121)

dimensionI <- 15
triangle <- matrix(c(rep(0,(dimensionI+1)^2)),nrow=dimensionI+1,ncol=dimensionI+1)
rectangle <- matrix(c(rep(0,(dimensionI+1)^2)),nrow=dimensionI+1,ncol=dimensionI+1)
exposure <- round(runif(dimensionI+1,min=9000,max=11000)+seq(500,(dimensionI+1)*500,by=500),0)
claimfrequency <- c(rep(0.1,dimensionI+1))

notifprop <- matrix(c(rep(0,(dimensionI+1)^2)),nrow=dimensionI+1,ncol=dimensionI+1)

for (i in 1:(dimensionI+1)){
  notifprop[i,]<-discretise(pgamma(x,1.5+i/10),method="rounding",from=0, to=dimensionI+1,step=1)
  rectangle[i,] <- rmultinom(1,rpois(1,exposure[i]*claimfrequency[i]),notifprop[i,])
  triangle[i,1:(dimensionI-i+2)] <- rectangle[i,1:(dimensionI-i+2)]
}

dataset <- as.data.frame(cbind(exposure,triangle))

dataset_t <- as.data.frame(cbind(exposure,triangle))
dataset_r <- as.data.frame(cbind(exposure,rectangle))

write_xlsx(
  dataset_t,
  path = paste("LRcounts2-triangle.xlsx",sep=""),
  col_names = FALSE,
  format_headers=FALSE
)

write_xlsx(
  dataset_r,
  path = paste("LRcounts2-rectangle.xlsx",sep=""),
  col_names = FALSE,
  format_headers=FALSE
)


#################
# LRcounts3

set.seed(308231317)

dimensionI <- 15
triangle <- matrix(c(rep(0,(dimensionI+1)^2)),nrow=dimensionI+1,ncol=dimensionI+1)
rectangle <- matrix(c(rep(0,(dimensionI+1)^2)),nrow=dimensionI+1,ncol=dimensionI+1)
exposure <- round(runif(dimensionI+1,min=9000,max=11000)-seq(100,(dimensionI+1)*100,by=100),0)
claimfrequency <- c(rep(c(0.1,0.2),(dimensionI+1)/2))

notifprop <- matrix(c(rep(0,(dimensionI+1)^2)),nrow=dimensionI+1,ncol=dimensionI+1)

for (i in 1:(dimensionI+1)){
  notifprop[i,]<-discretise(pgamma(x,1.5+(i/4-floor(i/4))*2),method="rounding",from=0, to=dimensionI+1,step=1)
  rectangle[i,] <- rmultinom(1,rpois(1,exposure[i]*claimfrequency[i]),notifprop[i,])
  triangle[i,1:(dimensionI-i+2)] <- rectangle[i,1:(dimensionI-i+2)]
}

dataset <- as.data.frame(cbind(exposure,triangle))

dataset_t <- as.data.frame(cbind(exposure,triangle))
dataset_r <- as.data.frame(cbind(exposure,rectangle))

write_xlsx(
  dataset_t,
  path = paste("LRcounts3-triangle.xlsx",sep=""),
  col_names = FALSE,
  format_headers=FALSE
)

write_xlsx(
  dataset_r,
  path = paste("LRcounts3-rectangle.xlsx",sep=""),
  col_names = FALSE,
  format_headers=FALSE
)

