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
  # filter(entidad %in% c("VIVIENDA", "HOGAR", "PERSONA")) %>%
  filter(entidad %in% c("PERSONA")) %>%
  filter(variable %in% c("P56B", "P56C",
                         "P57A", "P57B", "P57C", "P58A", "P58B", "P59", "P60", "P29R0",
                         "P29R1", "P29R2", "P29R3", "P29R4", "P38AE", "P52R1", "P54R1", 
                         "P45R1A", "P56T", "P57T", "P39R2", "P38AEST", "CAPECON")) %>% 
  # filter(!variable %in% c("H35", "P27")) %>% 
  mutate(entidad_variable = paste0(entidad, ".", variable)) %>% 
  dplyr::select(entidad_variable) %>% 
  distinct()

etl.dicc_ls <- lapply(unname(as.list(as.data.frame(
  t(etl.dicc)))), 
  as.character)

# End()