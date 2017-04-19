# Funciones

# Trata los niveles de un factor como numericos
as.numeric.factor <- function(x) {as.numeric(levels(x))[x]}

# Pone en minúscula los nombres de todas las columnas de una lista de data frames
ltolower <- function(df) {
  x <- get(df)
  colnames(x) <- tolower(colnames(x))
  assign(df, x, envir = .GlobalEnv)
  NULL
}

# Pone en mayúscula la primera letra de una palabra
simpleCap <- function(x) {
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2),
        sep="", collapse=" ")
}

# Prueba si existe un paquete, y si no lo instala
pkgTest <- function(x)
{
  if (!require(x,character.only = TRUE))
  {
    install.packages(x,dep=TRUE)
    if(!require(x,character.only = TRUE)) stop("Package not found")
  }
}

# Select Functions for Oracle
select_meta <- function(a){
  b <- paste(
    "SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, DATA_LENGTH
    FROM ALL_TAB_COLS 
    WHERE OWNER = 'DBAPER' AND TABLE_NAME =",
    a)
  return(b)
} 

select_sample <- function(a,b){
  c <- paste0(
    "SELECT * FROM DBAPER.", a, " ", "WHERE ROWNUM <= ", b)
  return(c)
} 

# Elimina todas las columnas en las que todos sus valores son NA,
# pero deja aquellas columnas en las que solo algunos valores son NA ...
# df.new <- df[ , ! apply( df , 2 , function(x) all(is.na(x)) ) ]
# ... o mas compacto
# df.new <- Filter(function(x) !all(is.na(x)), df)
# Pendiente revisar si definición debajo funciona
# notcolallisna <- function(dfold, dfnew) {
#    df <- get(dfold)
#    Filter(function(x) !all(is.na(x)), df)
#    assign(dfnew, df, envir = .GlobalEnv)
#    print(struc(get(dfnew)))
# }


# Fin()