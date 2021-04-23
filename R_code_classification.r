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

#Gran Canyon 
#https://earthobservatory.nasa.gov/images/80948/exploring-the-grand-canyon
#When John Wesley Powell led an expedition down the Colorado River and through the Grand Canyon in 1869, he was confronted with a daunting landscape. At its highest point, the serpentine gorge plunged 1,829 meters (6,000 feet) from rim to river bottom, making it one of the deepest canyons in the United States. In just 6 million years, water had carved through rock layers that collectively represented more than 2 billion years of geological history, nearly half of the time Earth has existed.

setwd('C:/Users/Sery/Desktop/lab')
library(raster)
library(RStoolbox)

#il file è in RGB, quindi si utilizza la funzione brick
gc <- brick('dolansprings_oli_2013088_canyon_lrg.jpg')
plotRGB(gc, r=1, g=2, b=3, stretc='lin')
plotRGB(gc, r=1, g=2, b=3, stretc='hist') #strech ancora più alto dei valori, in modo da visualizzare più variazioni di colore possibili (tutte le gamme delle bande RGB)

#classificazione dell'immagine: si misura la distanza di ogni pixel da un valore multispettrale e si raggruppano a seconda della distanza minore dal valore
#funzione unsuperClass (all interno del pacchetto RStoolbox): classifica i pixel dell'immagine in base alla classe che scegliamo 
#facciamo un modello dell'immagine, quindi avremo la mappa e le informazioni delle classi, per visualizzare solo la mappa nel plot bisogna legarla con $
gcc2 <- unsuperClass(gc, nClasses=2)
plot(gcc2$map)
# con 4 classi
gcc4 <- unsuperClass(gc, nClasses=4)
plot(gcc4$map)
