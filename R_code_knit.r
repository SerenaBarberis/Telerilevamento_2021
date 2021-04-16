#R_code_knit.r

setwd('C:/Users/Sery/Desktop/lab')
library(knitr)
#knitr: genera un report che andrà a salvare nella stessa cartella del codice che abbiamo salvato (R_code_greenland.r)
#funzione stitch: primo argomento è il nome del codice (R_code_greenland.r); template->misc 

stitch('R_code_greenland.r.txt', template=system.file("misc", "knitr-template.Rnw", package="knitr"))
#produce un file .tex
# crea una cartella figure con le singole immagini in formato pdf






