library(RSQLite)
library(DBI)
library(tidyverse)

data <- data.frame(
  NAME = c("Afda")
  ,CALORIES = c(1150)
)

# Create an ephemeral in-memory RSQLite database
con <- dbConnect(RSQLite::SQLite(), "calories.sqlite")

#write new  table
#dbWriteTable(con, "calories", data)
dbReadTable(con, "calories")

dbExecute(con, "INSERT INTO calories VALUES ('Afda', 15350)")


dbReadTable(con, "calories")

# Clear the result
dbClearResult(res)

# Disconnect from the database
dbDisconnect(con)