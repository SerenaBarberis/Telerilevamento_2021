#R_code_classification.r

setwd('C:/Users/Sery/Desktop/lab')
library(raster)
library(RStoolbox)

#funzione brick: prende un pacchetto di dati e crea un raste con bande RGB
so <- brick("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")

#funzione plotRGB: permette di visualizzare il rasterbrick
plotRGB(so, 1,2,3, stretch='lin')

#funzione unsuperClass (pacchetto RStoolbox):opera la classificazione non supervised dei pixel. vengono scelti il numero di classi (in questo caso 3)
soc <- unsuperClass(so, nClasses=3) #crea un modello di classificazione e una mappa, che per vedere bisogna plottarla (collegandola con $)
cl <- colorRampPalette(c('yellow','red','black'))(100)
plot(soc$map, col=cl) #funzione set.seed per considerare gli stessi pixel, altrimenti l'immagine può variare perchè considera diversi pixel

#classificazione unsupervised con 20 classi
set.seed(42)
soe <- unsuperClass(so, nClasses=20)
plot(soe$map, col=cl)
#download imagine from https://www.esa.int/ESA_Multimedia/Missions/Solar_Orbiter/(result_type)/images and make the unsupervised classification
sun <- brick('sun.png')
sunc <-unsuperClass(sun, nClasses=3)
plot(sunc$map)
# con 20 classi
sunc <-unsuperClass(sun, nClasses=20)
plot(sunc$map)









