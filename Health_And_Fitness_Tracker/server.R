library(shiny)
library(rvest)
library(dplyr)
library(ggplot2)
library(DT)

## -----------------------------------------------------------------------------------------------------------------------------
## Web Scrapping from a website collecting all list of foods in Malaysia and its calories
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

# Removing the unnecessary value in the Dataset
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

## -----------------------------------------------------------------------------------------------------------------------------







shinyServer(function(input, output, session) {

  ## ---------------------------------------------------------------------------------------------------------------------------
  ## These code here will be the user's info in Info Box such as name, gender, height, weight, age and BMI of the current user
  output$usersName <- renderInfoBox({
    infoBox(
      "User's Name", input$userName, icon = icon("user"), color = "blue", fill = TRUE
    )
  })
  output$usersWeight <- renderInfoBox({
    infoBox(
      "User's Weight", paste(input$userWeight, "KG"), icon = icon("weight"), color = "purple", fill = TRUE
    )
  })
  output$usersHeight <- renderInfoBox({
    infoBox(
      "User's Height", paste(input$userHeight, "CM"), icon = icon("ruler-vertical"), color = "yellow", fill = TRUE
    )
  })
  output$usersAge <- renderInfoBox({
    infoBox(
      "User's Age", paste(input$userAge, "Years"), icon = icon("sort-numeric-down"), color = "fuchsia", fill = TRUE
    )
  })
  output$usersGender <- renderInfoBox({
    gender <- switch(input$userGender,
                     male = "Male",
                     female = "Female")
    infoBox(
      "User's Gender", gender, icon = icon("venus-mars"), color = "teal", fill = TRUE
    )
  })
  output$usersBMI <- renderInfoBox({
    BMI <- input$userWeight/((input$userHeight)/100)^2
    if(BMI < 18.5){
      colourChoosen <- "blue"
      status <- "Underweight"
    }else if(BMI>=18.5 && BMI<=24.9){
      colourChoosen <- "green"
      status <- "Healthy"
    }else if(BMI>=25.0 && BMI<=29.9){
      colourChoosen <- "orange"
      status <- "Overweight"
    }else{
      colourChoosen <- "red"
      status <- "Obesity"
    }
    
    infoBox(
      "User's BMI", sprintf(BMI, fmt = '%#.2f'), status, icon = icon("balance-scale"), color = colourChoosen, fill=TRUE
    )
  })
  ## ---------------------------------------------------------------------------------------------------------------------------
  ## Code here will display the food list in first panel box
  
  output$food_table <- renderDataTable({
    
    Food_Calories_List
    
  })
  
  ## --------------------------------------------------------------------------------------------------------------------------
  ## Code here will display calories needed. If gender chosen is men or woman and how many and percent users consumed today.
  
  output$gendercalory <- renderText({
    
    genderChoose <- switch(input$userGender, 
                           male = "Men Daily Calory Requirement",
                           female = "Woman Daily Calorie Requirement")
  })
  output$caloryneed <- renderDataTable({
    
    genderChoose <- switch(input$userGender,
                           female = data.frame(
                             Age_Range = c("19 - 30 Years", "31 - 59 Years", "60+ Years"),
                             Calories_Needed = c("2000 - 2400 Calories", "1800 - 2200 Calories", "1600 - 2000 Calories")
                           ),
                           male = data.frame(
                             Age_Range = c("19 - 30 Years", "31 - 59 Years", "60+ Years"),
                             Calories_Needed = c("2400 - 3000 Calories", "2200 - 3000 Calories", "2000 - 2600 Calories")
                           ))
  })
  
  output$dailycalorie <- renderText({
    yourAge <- input$userAge
    
    yourTodayCalorie <- input$totalCalories
    
    yourGender <- switch(input$userGender,
                         male = "Male",
                         female = "Female")
    
    if(yourGender == "Male"){
      
      if(yourAge > 18 && yourAge < 31){
        maxCal = 3000
        minCal = 2400
      }else if(yourAge > 30 && yourAge < 60){
        maxCal = 3000
        minCal = 2200
      }else{
        maxCal = 2600
        minCal = 2000
      }
      
      
    }else if(yourGender == "Female"){
      
      if(yourAge > 18 && yourAge < 31){
        maxCal = 2400
        minCal = 2000
      }else if(yourAge > 30 && yourAge < 60){
        maxCal = 2200
        minCal = 1800
      }else{
        maxCal = 2000
        minCal = 1600
      }
      
    }
    
    if(yourTodayCalorie > maxCal){
      
      percentCal <- ((yourTodayCalorie - maxCal)/maxCal) * 100
      differCal <- yourTodayCalorie - maxCal
      
      print(paste("You consumed more than suggested daily calorie which is",
                  sprintf(percentCal, fmt = '%#.2f'), "% more. Hopefully you do extra exercise to burn execessive calories."))
      
      
    }else if(yourTodayCalorie < minCal){
      
      percentCal <- ((minCal - yourTodayCalorie)/minCal) * 100
      differCal <- minCal - yourTodayCalorie
      
      print(paste("You consumed less than suggested daily calories which is",
                  sprintf(percentCal, fmt = '%#.2f'), "% less. Eat more food to stay healthy and energetic"))
      
    }else{
      
      print("The amount of calories you consumed today is normal. KEEP UP THE GOOD WORK!!!")
      
    }
    
  })
  ## ---------------------------------------------------------------------------------------------------------------------------
  
  

})
