library(deSolve)
library(tidyverse)
library(RJSONIO)
library(reshape2)
library(knitr)


# set parameter vectors
num <- 5 # number of oscillators
#a <- c(1.43,1.1,2.2,1.2,3.2)
a <- runif(num, min = 1, max = 4)
#b <- c(0.18,0.3,0.1,0.2,0.4)
b <- runif(num, min = 0.1, max = 0.5)
#k <- c(1,1,1,1,1)
k <- runif(num, min = 1, max = 2)
#gamma <- c(1,0.2,0.5,1,0.1)
#gamma <- c(0.1,0.1,0.1,0.1,0.1)
gamma <- runif(num, min = 0.1, max = 0.3)

#ysini <- c(-0.4*sin(7*pi/6),0.2*cos(0),-0.3*sin(0),0.5*cos(pi/4),0.4*cos(3*pi/2)) + 1
#xsini <- c(-0.4*cos(7*pi/6),-0.2*sin(0),-0.3*cos(0),-0.5*sin(pi/4),-0.4*sin(3*pi/2))
xsini <- rep(runif(1, min = 0, max = 1)*sin(runif(1, min = 0, max = 10)*pi/runif(1, min = 0, max = 10)), num)
ysini <- rep(runif(1, min = 0, max = 1)*sin(runif(1, min = 0, max = 10)*pi/runif(1, min = 0, max = 10)), num)
# compute initial volume
Vsini <- a - b*ysini
Init_vol <- sum(Vsini)

# set all initial conditions
yini <-c(ysini,xsini,Init_vol)
myDEs <- function(t,y,parms){
  
  l_n <- length(y)-1
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
  
  
  ddt <- c(dysdt,dxsdt,0)
  
  return(list(ddt))
  
}

# simulate
times <- seq(0,100,by=0.1) # desired time values
# call to ode solver
out <- ode(y = yini, times = times, func = myDEs, parms = NULL)

# post-process
time_state_vals <- out[ ,1:(length(a)+1)]
time_state_vals <- as.data.frame(time_state_vals)
names(time_state_vals) <- c("time_vals","state1","state2","state3","state4","state5")

time_state_vals %>% gather(state1,state2,state3,state4,state5,key = "state",value="value") %>%
  ggplot(aes(x=time_vals,y=value,color=state)) + 
  geom_line(lwd=1) + ggtitle("Oscillator Dynamics")

time_state_valsOne <- time_state_vals
time_state_valsOne$state1 <- a[1] - b[1]*time_state_valsOne$state1
time_state_valsOne$state2 <- a[2] - b[2]*time_state_valsOne$state2
time_state_valsOne$state3 <- a[3] - b[3]*time_state_valsOne$state3
time_state_valsOne$state4 <- a[4] - b[4]*time_state_valsOne$state4
#time_state_valsOne$state5 <- -1/b[n]*(b[1]*time_state_valsOne$state1 + b[2]*time_state_valsOne$state2 +b[3]*time_state_valsOne$state3 + b[4]*time_state_valsOne$state4)
time_state_valsOne$state5 <- a[5] - b[5]*time_state_valsOne$
  state5

time_state_valsOne %>% gather(state1,state2,state3,state4,state5,key = "state",value="value") %>%
  ggplot(aes(x=time_vals,y=value,color=state)) + 
  geom_line(lwd=1) + ggtitle("Oscillator Dynamics")
ls()

exportJson <- toJSON(time_state_valsOne)
write(exportJson, "oscillations.json")

