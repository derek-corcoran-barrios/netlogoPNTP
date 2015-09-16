# Aca en el nlDir hay que poner el directorio para llegar a donde esta instalado netlogo
library(RNetLogo)
nlDir <- "C:/Program Files (x86)/NetLogo 5.1.0"
setwd(nlDir)

nl.path <- getwd()
NLStart(nl.path)
# En NLLoadModel va el directorio donde guardas el modelo

NLLoadModel <-"C:/Users/usuario/netlogoPNTP/total.nlogo"

#Ahora metemos la parte expacialmente explicita en el modelo

NLCommand("load-gis")    # carga el sig desde el archivo ascii
NLCommand("get-paths")   # obtiene los valores del raster 

#Seteamos los parametros del modelo

NLCommand("set num-tourists to 20") # numero de turistas, valores entre 0 y 300
NLCommand("set proportion to 0.46") # proporcion de turistas que empieza en hosteria las torres entre 0 y 1
NLCommand("set time-of-stay to 134") # cuanto tiempo se queda un turista en un campamento de 0 a 180 ticks
NLCommand("set threshold to 70") # cuanto es conciderado un exceso de turistas en un campamento entre 1 y 400
NLCommand("set ticks-to-an-hour to 50") # cuantos ticks son una hora entre 38 y 100

#hacemos andar el modelo
NLCommand("go")                # Abrir el modelo desde R