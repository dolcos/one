driver.name <- "/usr/lib64/libtdsodbc.so"
db.name <- "CensoRD"
host.name <- "comunidad-analitica.database.windows.net" #ip #\\
port.odbc <-""
user.name <-"SQLAdmin"
pwd <- "Steve99Jobs*"
trust <- "no"

con.text <- paste("DRIVER=",driver.name,
                  ";Database=",db.name,
                  ";Server=",host.name,
                  ";Port=",port.odbc,
                  ";PROTOCOL=TCPIP",
                  ";UID=", user.name,
                  ";pwd=", pwd,
                  ";TrustServerCertificate=", trust,
                  sep="")

# Open Connection
conodbc <- odbcDriverConnect(con.text)

diccionario <- readRDS("./data/raw_dicc_cpv2010.rds")

sqlSave(conodbc, diccionario, tablename = "dbo.diccionario", 
        rownames = FALSE, safer = FALSE, append = TRUE)

test <- sqlQuery(conodbc, "SELECT * FROM dbo.diccionario", 
                 stringsAsFactors = FALSE)

close(conodbc)