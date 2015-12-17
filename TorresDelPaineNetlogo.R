library(RNetLogo)
library(dplyr)
library(ggplot2)
library(car)

nl.path <- "C:/Program Files (x86)/NetLogo 5.2.1"
NLStart(nl.path, gui=TRUE)

model.path <- file.path("C:/Users/corcoranbarriosd/Documents/Paine/total.nlogo")
NLLoadModel(model.path)
NLCommand("load-gis")
NLCommand("get-paths")
NLCommand("setup")

NLDoCommand(351, "go")

DF <- NLDoReport(50000, "go", c("(ticks + 600) / (ticks-to-an-hour * 24)","count tourists"), as.data.frame = TRUE, df.col.names = c("Days", "Total.tourists"))
#NLDoCommand(38400, "go")
DF <- mutate(DF, day = ceiling(Days))
DF <- mutate(DF, time = Days-(day-1))

SumDF <-summarise(group_by(DF, day), mean = mean(Total.tourists), max.tourists = max(Total.tourists))

#a <-lm(logit(mean/SumDF$mean[length(SumDF$mean)])~day,data=SumDF)
#asympt <-nls(mean~phi1/(1+exp(-(phi2+phi3*day))), start=list(phi1=400,phi2=-5.4567,phi3=.101),data=SumDF,trace=TRUE)

ggplot(SumDF, aes(x= day, y = mean)) + geom_point() + geom_smooth()

DF <- filter(DF, day > 6)
DF$day <- as.factor(DF$day)
DF$time <- as.factor(DF$time)
AV.day <- summarise(group_by(DF, time), mean = mean(Total.tourists), SD = sd(Total.tourists))
Av.day <- mutate(AV.day, up = mean + SD, low = mean - SD)
ggplot(Av.day, aes(x= as.numeric(time), y = mean)) + geom_line() + geom_ribbon(aes(ymax= up, ymin = low))

NLCommand("clear-all")
NLQuit()