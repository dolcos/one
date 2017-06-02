# MASTER

# Scripts
# zlog <- file("./outs/zlog.log", open="wt")
# sink(zlog, type = "message")
source(paste0(funs,      "paquetes.R"))
source(paste0(funs,      "conexion.R"))
#try( 
system.time( source("01_dictionary.R") )
system.time( source("02_data.R") )
#)
source(paste0(funs,      "desconexion.R"))
# sink()

# End()