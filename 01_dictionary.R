# Diccionario Redatam CPV2010 #### 

raw.dicc_cpv2010 <- read_html("http://redatam.one.gob.do/cgibin/RpWebEngine.exe/Dictionary?&BASE=CPV2010&ITEM=DICALL&MAIN=WebServerMain.inl") %>% 
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
  mutate(entidad = str_replace_all(entidad, "[[:space:]]", ""),
         grupo = str_replace_all(grupo, "[[:space:]]", "")
   ) %>%
  mutate(entidad = ifelse(entidad == "", NA, entidad),
         rotulo_variable = ifelse(rotulo_variable == "", NA, rotulo_variable),
         grupo = ifelse(grupo == "", NA, grupo)) %>%
  fill(c(entidad, rotulo_variable, grupo)) %>% 
  mutate(grupo = ifelse(entidad %in% c("MORTA", "AGRICOLA", "PECUARIA"), "", grupo),
         grupo = ifelse(alias =="" & grupo != "UBIGEO" & is.null(grupo)==FALSE, "", 
                        grupo)) %>% 
  filter(nchar(variable) > 1)
  # dplyr::select(id, entidad, variable, rotulo_variable, grupo, alias, everything())

# urls valores variables diccionario ####
one.catviv <- "http://redatam.one.gob.do/cgibin/RpWebEngine.exe/Dictionary?&BASE=CPV2010&ITEM=DICCATVIV&MAIN=WebServerMain.inl"
one.cathog <- "http://redatam.one.gob.do/cgibin/RpWebEngine.exe/Dictionary?&BASE=CPV2010&ITEM=DICCATHOG&MAIN=WebServerMain.inl"
one.catpob <- "http://redatam.one.gob.do/cgibin/RpWebEngine.exe/Dictionary?&BASE=CPV2010&ITEM=DICCATPER&MAIN=WebServerMain.inl"

# remDr$open()
# remDr$navigate(one.catviv)
# Sys.sleep(30)
# remDr$close

saveRDS(raw.dicc_cpv2010, file = "./data/raw_dicc_cpv2010.rds")

etl.dicc <- raw.dicc_cpv2010 %>%
  filter(row_number() %in% c(181, 182, 183, 184, 185, 186, 
                             188, 190, 193, 196, 199, 205, 215, 217, 218)) %>% 
  filter(entidad %in% c("VIVIENDA", "HOGAR", "PERSONA", "MORTA")) %>% 
  filter(!variable %in% c("H35", "P27")) %>% 
  mutate(entidad_variable = paste0(entidad, ".", variable)) %>% 
  dplyr::select(entidad_variable) %>% 
  distinct()

etl.dicc_ls <- lapply(unname(as.list(as.data.frame(
  t(etl.dicc)))), 
  as.character)

# End()