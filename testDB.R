library(RSQLite)
library(DBI)
library(tidyverse)

data <- data.frame(
  NAME = c("Afda")
  ,CALORIES = c(1400)
  ,BURN = c(500)
  ,WEIGHT = c(90)
  ,DATE = c ("2022-01-17")
  
)

# Create an ephemeral in-memory RSQLite database
con <- dbConnect(RSQLite::SQLite(), "Health_And_Fitness_Tracker/totalData.sqlite")

#write new  table
#dbWriteTable(con, "data", data)
#dbReadTable(con, "data")

#dbExecute(con, "INSERT INTO data VALUES ('Idzhans', 3000, 360,52,'2022-01-18')")
#dbExecute(con, "INSERT INTO data VALUES ('Idzhans', 3890, 590,99,'2022-01-19')")
#dbExecute(con, "INSERT INTO data VALUES ('Idzhans', 3543, 520,68,'2022-01-20')")
#dbExecute(con, "INSERT INTO data VALUES ('Idzhans', 5980, 520,85,'2022-01-21')")
#dbExecute(con, "INSERT INTO data VALUES ('Idzhans', 3800, 240,99,'2022-01-22')")
#dbExecute(con, "INSERT INTO data VALUES ('Idzhans', 5820, 620,55,'2022-01-23')")
#dbExecute(con, "INSERT INTO data VALUES ('Afda', 3000, 480,20,DATE('now','localtime'))")
#dbExecute(con, "DELETE FROM data WHERE DATE = '2022-01-25'")
#dbExecute(con, "DELETE FROM data WHERE CALORIES = '380'")
#dbExecute(con, "DROP TABLE data")

dbReadTable(con, "data")

data <- tbl(con,"data")
temp <- collect(data)
name <- "Idzhans"
temp2 <- filter(temp,NAME == name)
totalData <- tail(temp2,n=7)
ggplot(totalData, aes(x = DATE, group = 3 )) +
  geom_point(aes(y = CALORIES)) +
  geom_point(aes(y = BURN)) +
  geom_point(aes(y = WEIGHT * 40)) +
geom_line(aes(y = CALORIES), color = "green", size = 1, linetype = 1) +
geom_line(aes(y = BURN), color = "red", size = 1, linetype = 2) +
geom_line(aes(y = WEIGHT * 40), color = "blue", size = 1, linetype = 3) +
  
  scale_linetype(' ') +
  
  scale_y_continuous(name = "Calories",
                     
                     sec.axis = sec_axis(~./40, name = "Weight (kg)")
                     
  )

# Clear the result
#dbClearResult(con)

# Disconnect from the database
#dbDisconnect(con)