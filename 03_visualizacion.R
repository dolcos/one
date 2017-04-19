

# Visualizando Información Geográfica
# Lee los archivos .shp
prov <- readOGR(dsn=path.expand(paste0(dirmap,"PROVCenso2010.shp")), 
                layer="PROVCenso2010")
# summary(prov)

# Encoding(levels(prov$TOPONIMIA)) <- "UTF-8"

# Centroides para las etiquetas
centroids.df <- as.data.frame(coordinates(prov))
names(centroids.df) <- c("cLon", "cLat")  #more sensible column names
prov@data$cLon <- centroids.df$cLon
prov@data$cLat <- centroids.df$cLat

# Fortifica para ggplot & join
provf <- fortify(prov, region = "PROV")
provf$id <- as.numeric(as.character(provf$id))
prov@data$id = as.numeric(as.character(prov@data$PROV))
p1ventas.sum$cregion <- as.numeric(as.character(p1ventas.sum$cregion))
prov.df <- provf %>% left_join(prov@data) %>% 
  left_join(p1ventas.sum, by = c("id" = "cregion"))

# Embellece las etiquetas
prov.df$TOPO <- as.character(prov.df$TOPONIMIA)
prov.df$TOPO <- tolower(prov.df$TOPO) 
prov.df$TOPO <- unlist(lapply(prov.df$TOPO, simpleCap))
prov.df$TOPO <- str_wrap(prov.df$TOPO, width = 10)
prov.df$TOPO_VAL <- str_wrap(ifelse(is.na(prov.df$x),
                                    prov.df$TOPO,
                                    paste0(prov.df$TOPO, 
                                    "\n", 
                                    comma(prov.df$x))), 
                             width = 10)

# Ventas Totales de P1 por Provincia
p1ventas.map <- choroit2(prov.df, 
                         "(id %in% 
                         c(1,11,13,21,25,28,32))", 
                         prov.df, 
                         "x", "Ventas", "TOPO_VAL", 
                         "Ventas Totales de P1\n por Provincia")

ggsave(paste0(dirout, "p1ventas_map.png"), 
       plot = p1ventas.map, 
       width=12.5, height=8.25, dpi=200)


# Fin()
