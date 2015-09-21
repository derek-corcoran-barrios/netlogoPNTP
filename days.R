Turistas.totales <- read.csv("C:/Users/usuario/netlogoPNTP/total1 Turistas totales.csv")

library (dplyr)

Turistas.totales <- mutate(Turistas.totales, Day= Ticks / (24*50))

plot(Tourists~Day, data= Turistas.totales, type ="l")
