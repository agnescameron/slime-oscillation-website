library(deSolve)
library(tidyverse)
library(RJSONIO)
library(reshape2)

# set parameter vectors
num <- 5 # number of oscillators
a <- runif(num, min = 1, max = 4)
b <- runif(num, min = 0.1, max = 0.5)
k <- runif(num, min = 1, max = 2)
gamma <- runif(num, min = 0.1, max = 0.3)

#ysini <- c(-0.4*sin(7*pi/6),0.2*cos(0),-0.3*sin(0),0.5*cos(pi/4),0.4*cos(3*pi/2)) + 1
#xsini <- c(-0.4*cos(7*pi/6),-0.2*sin(0),-0.3*cos(0),-0.5*sin(pi/4),-0.4*sin(3*pi/2))
xsini <- rep(runif(1, min = 0, max = 1)*sin(runif(1, min = 0, max = 10)*pi/runif(1, min = 0, max = 10)), num)
ysini <- rep(runif(1, min = 0, max = 1)*sin(runif(1, min = 0, max = 10)*pi/runif(1, min = 0, max = 10)), num)
yini <- c(ysini,xsini)

Vsini <- a - b*ysini
Init_vol <- sum(Vsini)

myDEs <- function(t,y,parms){
  
  l_n <- length(y)
  n <- l_n/2
  ys <- y[1:n]
  xs <- y[(n+1):l_n]
  dysdt <- xs
  Vs <- a - b*ys
  dxsdt <- -k*ys
  dxsdt[1] <- dxsdt[1] + gamma[1]*(0.5*Vs[2] - Vs[1]) # first
  dxsdt[2] <- dxsdt[2] + gamma[2]*(Vs[1]+0.5*Vs[3] - Vs[2]) # second
  # middle oscillators
  dxsdt[3:(n-2)] <- dxsdt[3:(n-2)] + gamma[3:(n-2)]*(0.5*Vs[2:(n-3)] + 0.5*Vs[4:(n-1)] - Vs[3:(n-2)])
  
  dxsdt[n-1] <- dxsdt[n-1] + gamma[n-1]*(Vs[n] + 0.5*Vs[n-2] - Vs[n-1]) # second to last
  dxsdt[n] <- dxsdt[n] + gamma[n]*(0.5*Vs[n-1] - Vs[n]) # last 
  
  # impose volume constraint
  dysdt[n] <- -1/b[n]*sum(b[1:(n-1)]*dysdt[1:(n-1)])
  
  ddt <- c(dysdt,dxsdt)
  
  return(list(ddt))
  
}

times <- seq(0,1000,by=0.1) # time steps for the ODE

out <- ode(y = yini, times = times, func = myDEs, parms = NULL)

time_state_vals <- out[ ,1:(length(a)+1)]

time_state_vals <- as.data.frame(time_state_vals)

names(time_state_vals) <- c("time_vals","state1","state2","state3","state4","state5")

vars <- colnames(time_state_vals[,-1])
plot_var <- melt(time_state_vals, id.vars = "time_vals", measure.vars = vars)
ggplot(plot_var, aes(x = time_vals, y = value)) + geom_line(aes(color = factor(variable)), lwd = 1)

#time_state_valsOne <- time_state_vals
time_state_valsOne$state1 <- a[1] - b[1]*time_state_valsOne$state1
time_state_valsOne$state2 <- a[2] - b[2]*time_state_valsOne$state2
time_state_valsOne$state3 <- a[3] - b[3]*time_state_valsOne$state3
time_state_valsOne$state4 <- a[4] - b[4]*time_state_valsOne$state4
time_state_valsOne$state5 <- a[5] - b[5]*time_state_valsOne$state5

ls()

exportJson <- toJSON(time_state_valsOne)
write(exportJson, "test.json")

