library(rvest)
library(dplyr)

# Web Scrapping from a website collecting all list of foods in Malaysia and its calories
link = "https://health.family.my/health-facts/malaysian-food-calories-breakfast-teatime"
page = read_html(link)

# Collecting info from the website
food_name = page %>% html_nodes("td:nth-child(1)") %>% html_text()
food_calories = page %>% html_nodes("td:nth-child(3)") %>% html_text()
food_amount = page %>% html_nodes("td:nth-child(2)") %>% html_text()

# Putting some extra name in the data to avoid confusion
food_name <- data.frame(food_name)
food_name$food_name[129] <- paste("Pizza", food_name$food_name[129])
food_name$food_name[130] <- paste("Pizza", food_name$food_name[130])
food_name$food_name[131] <- paste("Pizza", food_name$food_name[131])
food_name$food_name[132] <- paste("Pizza", food_name$food_name[132])
food_name$food_name[136] <- paste("Pasta & Spaghetti -", food_name$food_name[136])
food_name$food_name[137] <- paste("Pasta & Spaghetti -", food_name$food_name[137])

# Removing the unnecessary value in the dataset
food_name <- data.frame(food_name)
food_name <- food_name[-c(1, 2, 3, 4, 19, 20, 21, 35, 36, 37, 42, 43, 44, 54, 55, 56, 61, 62, 63, 64, 81, 117, 118, 126, 127, 128, 133, 134, 
                          135, 138, 139, 140, 147, 148, 149, 165, 182, 187, 188, 189, 190, 191), ]

food_calories <- data.frame(food_calories)
food_calories <- food_calories[-c(1, 2, 3, 4, 19, 20, 21, 35, 36, 37, 42, 43, 44, 54, 55, 56, 61, 62, 63, 64, 81, 117, 118, 126, 127, 128, 133, 134, 
                          135, 138, 139, 140, 147, 148, 149, 165, 182, 187, 188, 189, 190, 191), ]

food_amount <- data.frame(food_amount)
food_amount <- food_amount[-c(1, 2, 3, 4, 19, 20, 21, 35, 36, 37, 42, 43, 44, 54, 55, 56, 61, 62, 63, 64, 81, 117, 118, 126, 127, 128, 133, 134, 
                              135, 138, 139, 140, 147, 148, 149, 165, 182, 187, 188, 189, 190, 191), ]

Food_Calories_List <- data.frame(FOOD = food_name, AMOUNT = food_amount, CALORIES = food_calories)



