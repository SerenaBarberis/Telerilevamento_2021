# R_code_remote_sensing_first_code.r #

setwd ("C:/Users/Sery/Desktop/lab")

install.packages("raster")
library(raster)

#brick function: serve per caricare i dati, importa i dati raster e li inserisce in R ("" perchè usciamo da R per prendere l'immagine nella cartella lab)

p224r63_2011 <- brick("p224r63_2011_masked.grd")

p224r63_2011 #informazioni sul file caricato, rasterbrick:serie di bande in formato raster; 1499 righe di pixel e 2967 colonne di pixel, 4447533 pixel totali per ogni singola banda; risoluzione 30m (landstat); 7 bande

#plot function: genera un'immagine del dato

plot(p224r63_2011)
