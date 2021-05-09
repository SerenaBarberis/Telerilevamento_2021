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

#classificazione unsupervised
d1c <- unsuperClass(defor1, nclasses=2)# produce modello e mappa con 2 valori (perchè abbiamo scelto 2 classi)
plot(d1c$map)
#set.seed() per avere lo stesso risultato

d2c <- unsuperClass(defor2, nclasses=2)
plot(d2c$map)

#con 3 classi
d2c3 <- unsuperClass(defor2, nClasses=3) #agricolo diviso in 2 classi
plot(d2c3$map)

#calcolo perdita di foresta (calcolo frequenza pixel di una certa classe, cioè classe foresta e classe agricolo) -> funzione freq
#defor1
freq(d1c$map) #numeri di pixel delle 2 classi
# aree agricole = 37039
# foresta = 304253
s1 <- 306583 + 34709
prop1 <- freq(d1c$map) / s1
# percentuali
# foreste: 89.1
# aree agricole: 10.9

#defor2
freq(d2c$map)
# aree aperte: 165055
# foreste: 177671
s2 <- 165055 + 177671
prop2 <- freq(d2c$map) / s2
# percentuali
# aree aperte: 48.2
# foreste: 51.8

#generazione dataset(dataframe), 3 colonne (cover, foresta, agricoltura), 2 righe (percentuale nel 1922, percentuale nel 2006)
cover <- c('Forest', 'Agricolture')
percent_1992 <- c(89.1, 10.9)
percent_2006 <- c(48.2, 51.8)
#funzione dataframe:crea una tabella
percentages<-data.frame(cover, percent_1992, percent_2006)

#facciamo il plot con ggplot, in cui definiamo l'estetica del grafico attraverso gli argomenti della funzione
#1922
p1<-ggplot(percentages, aes(x=cover, y=percent_1992, color=cover)) + geom_bar(stat="identity", fill="lightblue") #geom_bar-> grafico a barre
#2006
p2<-ggplot(percentages, aes(x=cover, y=percent_2006, color=cover)) + geom_bar(stat="identity", fill="lightblue")

#mettere i grafici in un'unica immagine
grid.arrange(p1, p2, nrow = 1)
