library(shiny)
library(rvest)
library(dplyr)
library(ggplot2)
library(DT)

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





shinyServer(function(input, output, session) {

  ## This will be the user's info in Info Box
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
  
  ## Code here will display the things in first panel box
  # Make reactive to store values
  food_table <- shiny::reactiveValues()
  
  #Get singular food
  food_df <- eventReactive(input$foodChoosen, {
    
    food_df <- Food_Calories_List[Food_Calories_List$FOOD == input$foodChoosen, "FOOD"] 
    
  })
  
  update <- observeEvent(input$removeFood, {
    isolate(food_table$Food_Calories_List <- food_table$Food_Calories_List[-(nrow(food_table$Food_Calories_List)), ])
  })
  
  update <- observeEvent(input$submitFood, {
    isolate(food_table$Food_Calories_List[nrow(food_table$Food_Calories_List) + 1,] )
  })
  
  output$food_table <- DT::renderDataTable(Food_Calories_List,  
                                       rownames=FALSE, options = list(pageLength = 5))
  
  
  
  ## Code here will display calories needed. If gender chosen is men or woman
  output$gendercalory <- renderText({
    
    genderChoose <- switch(input$userGender, 
                           male = "Men Daily Calory Requirement",
                           female = "Woman Daily Calorie Requirement")
  })
  output$caloryneed <- renderDataTable({
    
    genderChoose <- switch(input$userGender,
                           male = data.frame(
                             Age_Range = c("19 - 30 Years", "31 - 59 Years", "60+ Years"),
                             Calories_Needed = c("2000 - 2400 Calories", "1800 - 2200 Calories", "1600 - 2000 Calories")
                           ),
                           female = data.frame(
                             Age_Range = c("19 - 30 Years", "31 - 59 Years", "60+ Years"),
                             Calories_Needed = c("2400 - 3000 Calories", "2200 - 3000 Calories", "2000 - 2600 Calories")
                           ))
    
    
  })
  
  

})
