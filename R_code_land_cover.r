#R_code_land_cover.r

setwd('C:/Users/Sery/Desktop/lab')
install.packages('gridExtra') #permette di usare ggplot per dati raster
library(raster)
library(RStoolbox) #per la classificazione
library(ggplot2) 
library(gridExtra)

#NIR 1, RED 2, GREEN 3

defor1 <- brick("defor1.jpg")
plotRGB(defor1, r=1, g=2, b=3, stretch="Lin")

#funzione ggR (pacchetto ggplot): plottare i raster con grafici diversi
ggRGB(defor1,  r=1, g=2, b=3, stretch="Lin") #mostra le coordinate

#defor2
defor2 <- brick("defor2.jpg")
plotRGB(defor2, r=1, g=2, b=3, stretch="Lin")
ggRGB(defor2,  r=1, g=2, b=3, stretch="Lin")

par(mfrow=c(2,1))
plotRGB(defor1, r=1, g=2, b=3, stretch="Lin")
plotRGB(defor2, r=1, g=2, b=3, stretch="Lin")

par(mfrow=c(2,1))
ggRGB(defor1,  r=1, g=2, b=3, stretch="Lin")
ggRGB(defor2,  r=1, g=2, b=3, stretch="Lin")

#multiframe con ggplo2 e griExtra
p1 <- ggRGB(defor1,  r=1, g=2, b=3, stretch="Lin")
p2 <- ggRGB(defor2,  r=1, g=2, b=3, stretch="Lin")
grid.arrange(p1,p2, nrow=2)




