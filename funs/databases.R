# Conexion a Oracle usando ROracle #####
library(ROracle)
port <- 1521
drvora <- dbDriver("Oracle")
host <- "XX.XX.XX.XX"
sid <- "SID"
connect.string <- paste(
  "(DESCRIPTION=",
  "(ADDRESS=(PROTOCOL=tcp)(HOST=", host, ")(PORT=", port, "))",
  "(CONNECT_DATA=(SID=", sid, ")))", sep = "")
con.ora <- dbConnect(drvora, username =  Sys.getenv("user"),
                         password = Sys.getenv("pass"),
                         dbname = connect.string)
dbDisconnect(con.ora)

# Conexion a Oracle usando RJDBC ####
# library(RJDBC)
# drv <- JDBC("oracle.jdbc.OracleDriver", 
#             classPath="~/Documents/ojdbc/ojdbc14.jar", " ")
# con.ora.jdbc <- dbConnect(drv,"jdbc:oracle:thin:@XXX.XX.XXX.XX:1521:SCHEMA", 
#                  "user", "pass")
# dbDisconnect(con.ora.jdbc)

# Conexion a MS SQL Server via RODBC
# library(RODBC)
# driver.name <- "/usr/local/lib/libtdsodbc.so"
# db.name <- "BASE"
# host.name <- "XXX.XX.XXX.XXX"
# port.odbc <-""
# user.name <-"user"
# pwd <- "pass"
# 
# con.text <- paste("DRIVER=",driver.name,
#                   ";Database=",db.name,
#                   ";Server=",host.name,
#                   ";Port=",port.odbc,
#                   ";PROTOCOL=TCPIP",
#                   ";UID=", user.name,
#                   ";pwd=", pwd,
#                   sep="")
# con.odbc <- odbcDriverConnect(con.text)
# p <- sqlQuery(con.odbc, 
#               "select top 200 * from base.[dbo].[DimName]")
# close(con.odbc)
                                                
# Conexion a MS SQL Server via RJDBC #####
# drvsqljdbc <- JDBC("com.microsoft.sqlserver.jdbc.SQLServerDriver",
# "~/Documents/sqljdbc_6.0/enu/sqljdbc4.jar")
# con.mssql.jdbc <- dbConnect(drvsqljdbc, 
#                         "jdbc:sqlserver:XXX.XX.XXX.XXX", 
#                         "user", "pass")

# Conexión a MySQL via RMySQL ####
# library(RMySQL)
# con.mysql <- dbConnect(MySQL(), host="XXX.XX.XXX.XXX", 
#                        port= 3306, user = "user", 
#                        password = "passmysql", 
#                        dbname = "test")
# 
# dbDisconnect(con.mysql)

# Ejemplo real con RMySQL (Base Local)

# Conexión a MySQL via RMySQL
library(RMySQL)

con.mysql <- dbConnect(MySQL(), host="40.114.43.125", 
                       port= 3306, user = "athen", 
                       password = Sys.getenv("passmysql"),
                       dbname = "test")

dbListTables(con.mysql)

# df <- data.frame(date = c("2012-01-01", "2012-01-02"),
#                 value = c(23.2323, 34.343))

# dbWriteTable(con.mysql, 
#             "df", df, row.names=FALSE, 
#             field.types=list(
#               date="date", 
#               value="double(20,10)"), 
#             overwrite = TRUE)

library(ggplot2)
data(mpg)
View(mpg)

dbWriteTable(con.mysql, "mpg", 
             value = as.data.frame(mpg))

dbListTables(con.mysql)

mpg.mysql <- dbGetQuery(con.mysql, "select * from mpg")

dbRemoveTable(con.mysql, "mpg")
dbDisconnect(con.mysql)
rm(mpg, mpg.mysql, con.mysql)
gc()

# Conexion a MongoDB (RMongo) ####
library(RMongo)
mongo <- mongoDbConnect("test", "127.0.0.1", 27017)
# mongo.auth <- dbAuthenticate(mongo, "athen", Sys.getenv("passmongo"))

output <- dbInsertDocument(mongo, "test_data", '{"foo": "bar"}')  
output <- dbGetQuery(mongo, 'test_data', '{"foo": "bar"}')
print(output)

dbDisconnect(mongo)
rm(mongo, output)
gc()

# Conexion a MongoDB (mongolite) ####
library(mongolite)
m <- mongo(collection = "diamonds")

# Insert test data
data(diamonds, package="ggplot2")
m$insert(diamonds)

# Check records
m$count()
nrow(diamonds)

# Perform a query and retrieve data
out <- m$find('{"cut" : "Premium", "price" : { "$lt" : 1000 } }')

# Compare
nrow(out)
nrow(subset(diamonds, cut == "Premium" & price < 1000))

# End() ####

