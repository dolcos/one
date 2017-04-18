# Create project's directories

# Main directory
main <- getwd()

# Directories under main
dirs <- list()
dirs[['names']] <- c('funs', 
                     'data', 
                     'docs', 
                     'figs',
                     'outs'
)
dirs[['descr']] <- c('funciones y paquetes', 
                     'datos crudos', 
                     'documentos', 
                     'graficos',
                     'salidas'
)

dirs[['objs']] <- sapply(dirs[['names']], 
                         function(x) paste0(main, "/", x, "/"))

dirs.df <- as.data.frame(do.call(rbind, dirs))

invisible(
  sapply(names(dirs$objs), 
         function(x) assign(x, dirs$obj[[x]], 
                            envir = .GlobalEnv)
  )
)

# Create directory by template automation
dirls.create <- function(dirls) {
  for(x in dirls) {
    if (!dir.exists(file.path(x))) { 
      dir.create(file.path(x))
      cat(paste("", x, 
                "==> Creado ahora, favor verificar", "", sep = "\n"))
    } else { cat(paste("", x, 
                       "==> Ya había sido creado antes, cuidado", "", sep = "\n")) }
  }
}

# Be careful!
dirls.create(dirs$objs)

# Directories external to main
# comun <- "/home/comun/analitica/"

# End()