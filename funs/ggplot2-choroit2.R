choroit2 <- function(data = NULL, filter = NULL, map = NULL, 
                    fill=NULL, name=NULL, label=NULL, title=NULL) {
         filter <- noquote(filter)
         print(title)
         print(filter)
         print(fill)
         print(label)
         ggplot() +
           # base map layer
           geom_map(data=data, map=map,
                    aes(x=long, y=lat, group=group, map_id=id),
                    #na.rm=TRUE, 
                    fill="white", color="#7f7f7f", size=0.25) +
           # DR choro layer
           geom_map(data=subset(data, eval(parse(text=filter))), map=map, 
                    aes_string(fill = fill, map_id="id"), size=0.25) +
           scale_fill_distiller(name=name, palette = "Blues", 
                                labels=comma, breaks = pretty_breaks(n = 5), 
                                trans="reverse") +
           # Clean up map chart junk
           theme_nothing(legend = TRUE) +
           # Assign labels
           geom_text(data=data, 
                     aes_string(x="cLon", y="cLat", 
                         label = label, #angle = angle,
                         map_id = NULL), size=3 ,  color = 'black') +
           ggtitle(paste0(title,"\n "))
}

# test <- choroit2(prov.df, "id != 31", prov.df, 
#                "voluntario", "Volumen", "TOPO", "Test")

# End()