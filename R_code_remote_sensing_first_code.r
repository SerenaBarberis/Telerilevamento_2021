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

#bande di landsat
#B1: blu
#B2: verde
#B3: rosso
#B4: infrarosso vicino (prima lunghezza d'onda dopo il rosso più vicino al visibile)
#B5: infrarosso medio
#B6: termico
#B7: infrarosso medio

#$->lega la banda all'immagine satellitare totale (se non si vuole usare si può usare la funzione attach)
#plotto solo la banda del blu (B1_sre)
plot(p224r63_2011$B1_sre)
#plottare una sola banda con un'altra scala di colore
cl <- colorRampPalette(c('blue','green','grey', 'red', 'magenta', 'yellow'))(100)
plot(p224r63_2011$B1_sre,col=cl)

# funzione par: funzione generica, serve per plottare solo determinati elementi, decidendone la disposizione. (mf=multiframe)
#plottare la banda del blu assieme alla banda del verde

par(mfrow=c(1,2)) #1 riga e 2 colonne (par(mfrow=c(2,1)) 2 righe e 1 colonna #se si vogliono determinare prima il numero di colonne e poi le righe->par(fmcol..)
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)

# plottare le prime 4 bande di landsat
par(mfrow=c(4,1))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
plot(p224r63_2011$B3_sre)
plot(p224r63_2011$B4_sre)
# 2 righe e 2 colonne
par(mfrow=c(2,2))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
plot(p224r63_2011$B3_sre)
plot(p224r63_2011$B4_sre)

#per ogni banda mettiamo una diversa scala di colori, all'interno dello stesso grafico 2x2
par(mfrow=c(2,2))
clb <- colorRampPalette(c('dark blue','blue','light blue'))(100) 
plot(p224r63_2011$B1_sre, col=clb)

clg <- colorRampPalette(c('dark green','green','light green'))(100)
plot(p224r63_2011$B2_sre, col=clg)

clr <- colorRampPalette(c('dark red','red','pink'))(100)
plot(p224r63_2011$B3_sre, col=clr)

cln <- colorRampPalette(c('red','orange','yellow'))(100)
plot(p224r63_2011$B4_sre, col=cln)





