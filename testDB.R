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

dbExecute(con, "INSERT INTO data VALUES ('da', 3040, 530,92,'2022-01-18')")
dbExecute(con, "INSERT INTO data VALUES ('da', 3520, 520,89,'2022-01-19')")
dbExecute(con, "INSERT INTO data VALUES ('da', 2623, 420,88,'2022-01-20')")
dbExecute(con, "INSERT INTO data VALUES ('da', 4010, 120,85,'2022-01-21')")
dbExecute(con, "INSERT INTO data VALUES ('da', 2940, 140,79,'2022-01-22')")
dbExecute(con, "INSERT INTO data VALUES ('da', 2420, 720,85,'2022-01-23')")
#dbExecute(con, "INSERT INTO data VALUES ('Afda', 3000, 480,20,DATE('now'))")
#dbExecute(con, "DELETE FROM data WHERE DATE = '2022-01-24'")
#dbExecute(con, "DROP TABLE data")

#dbReadTable(con, "data")

data <- tbl(con,"data")
temp <- collect(data)
totalData <- tail(temp,n=7)
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