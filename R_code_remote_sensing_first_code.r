# R_code_remote_sensing_first_code.r #

setwd ("C:/Users/Sery/Desktop/lab")

install.packages("raster")
library(raster)

#brick function: serve per caricare i dati, importa i dati raster e li inserisce in R ("" perchè usciamo da R per prendere l'immagine nella cartella lab)
p224r63_2011 <- brick("p224r63_2011_masked.grd")

p224r63_2011 #informazioni sul file caricato, rasterbrick:serie di bande in formato raster; 1499 righe di pixel e 2967 colonne di pixel, 4447533 pixel totali per ogni singola banda; risoluzione 30m (landstat); 7 bande

#plot function: genera un'immagine del dato, applica una scala di colori default
plot(p224r63_2011)
#B1=blu       B5,B7=infrarosso medio
#B2=verde     B6= infrarosso termico, non è una riflettanza e ha una diversa risoluzione (in genere 60m invece che 30m)
#B3=rosso
#B4= NIR

#colorRampPalette function: stabilire la variazione dei colori (scala di colori) 
#c=array ->racchiude gli elementi in uno stesso argomento (in questo caso i colori)
#100= livelli di colore (sfumatura tra i 3 colori)

cl <- colorRampPalette(c('black','grey','light grey'))(100)
plot(p224r63_2011, col=cl)

#nuova scala di colori (si assiociano i colori ai valori di riflettanza)
cl <- colorRampPalette(c('blue','green','grey', 'red', 'magenta', 'yellow'))(100)
#cl <- colorRampPalette(c('blue','green', 'red', 'magenta', 'yellow'))(50)
plot(p224r63_2011, col=cl)




