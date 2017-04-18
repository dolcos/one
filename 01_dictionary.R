# Diccionario Redatam CPV2010 #### 

raw <- read_html("http://redatam.one.gob.do/cgibin/RpWebEngine.exe/Dictionary?&BASE=CPV2010&ITEM=DICALL&MAIN=WebServerMain.inl") %>% 
  html_nodes("div") %>%
  html_nodes("td") %>%
  html_nodes("table") %>% 
  html_table() %>% 
  as.data.frame() %>%
  rename_(.dots=setNames(names(.), tolower(names(.)))) %>% 
  rename(id = x.,
         entidad = nombre.de.la.entidad,
         variable = nombre.de.la.variable,
         rotulo_variable = rótulo) %>% 
  filter(str_detect(id, "IX Censo de Población y Vivienda 2010 - República Dom") == FALSE) %>% 
  filter(!is.na(as.numeric(id))) %>% 
  filter(entidad != "CPV2010") %>%
  mutate(entidad = ifelse(str_detect(entidad, "[[:space:]]")==TRUE, NA, entidad),
         rotulo_entidad = ifelse(is.na(entidad)==TRUE, NA, rotulo_variable),
         grupo = ifelse(str_detect(grupo, "[[:space:]]")==TRUE, NA, grupo)
  ) %>% 
  fill(c(entidad, rotulo_entidad, grupo)) %>% 
  mutate(grupo = ifelse(entidad %in% c("MORTA", "AGRICOLA", "PECUARIA"), "", grupo)) %>% 
  filter(nchar(variable) > 1) %>% 
  dplyr::select(id, entidad, rotulo_entidad, grupo, variable, alias, everything())

# urls valores variables diccionario ####
one.catviv <- "http://redatam.one.gob.do/cgibin/RpWebEngine.exe/Dictionary?&BASE=CPV2010&ITEM=DICCATVIV&MAIN=WebServerMain.inl"
one.cathog <- "http://redatam.one.gob.do/cgibin/RpWebEngine.exe/Dictionary?&BASE=CPV2010&ITEM=DICCATHOG&MAIN=WebServerMain.inl"
one.catpob <- "http://redatam.one.gob.do/cgibin/RpWebEngine.exe/Dictionary?&BASE=CPV2010&ITEM=DICCATPER&MAIN=WebServerMain.inl"

remDr$open()

remDr$navigate(one.catviv)
Sys.sleep(60)

remDr$close

# End()