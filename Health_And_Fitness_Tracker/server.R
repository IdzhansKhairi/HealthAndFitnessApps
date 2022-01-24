library(shiny)
library(rvest)
library(dplyr)
library(ggplot2)
library(DT)
library(hrbrthemes)

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

workoutdone <- data.frame(
  EXERCISE = c("Watching TV", "Reading Book", "Walking", "Jogging", "Playing Sports", "Workout"),
  CALORIES_BURNED_PER_MINUTE = c(1.17, 1.40, 6.67, 11.67, 10.92, 13.83)
)

testCalories <- data.frame(
  DAY = c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"),
  CALORIES = c(1400, 3000, 3500, 2600, 4000, 2900, 2900)
)

testBurned <- data.frame(
  DAY = c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"),
  BURNED = c(500, 480, 200, 900, 550, 140, 700)
)


testWeight <- data.frame(
  DAY = c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"),
  WEIGHT = c(90, 92, 89, 88, 85, 79, 85)
)


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
  
  output$food_table <- renderDataTable(
    
    Food_Calories_List, options = list(pageLength = 6)
    
  )
  
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
  # Code here will plot latest 7 days of users Food Consumption calories.
  
  output$plot_caloriesTaken <- renderPlot({
    
    # To make sure the day is in it's order and not alphabetical order
    testCalories$DAY <- factor(testCalories$DAY, levels=unique(testCalories$DAY)) 
    
    ggplot(testCalories, aes(x = DAY, y = CALORIES, group = 1)) +
      geom_point() +
      geom_line(color = "#00FF00", size = 1) +
      theme_ipsum() +
      ggtitle("Last 7 Days of Total Calories Consumed")
    
  })
  
  ## ---------------------------------------------------------------------------------------------------------------------------
  # Code here will show List of exercise and it's calories burned per minute
  
  output$exercise_table <- renderDataTable(
    
    workoutdone, options = list(pageLength = 6)
    
  )
  
  ## ---------------------------------------------------------------------------------------------------------------------------
  # Code here will show what exercise that you have done and how many calories should be burned
  
  output$exerciseImg <- renderUI({
    
    outfile <- switch(input$activityChoose,
                  tv = 'tv.gif',
                  read = 'read.gif',
                  walk = 'walk.gif',
                  jog = 'jog.gif',
                  sports = 'sports.gif',
                  workout = 'workout.gif' 
                 )
    
    tags$img(src = outfile, style="display: block; margin-left: auto; margin-right: auto;", width = "200px", height = "200px")
  })
  
  output$calBurnedText <- renderText({
    
    duration <- input$activityDuration
    
    
    calBurn <- switch(input$activityChoose,
                      tv = duration * 1.17,
                      read = duration * 1.40,
                      walk = duration * 6.67,
                      jog = duration * 11.67,
                      sports = duration * 10.92,
                      workout = duration * 13.83)
    
    text <- switch(input$activityChoose,
           tv = paste("The activity you has done today is WATCHING TELEVISION, and the duration of your activity is", duration, "minutes.",
                      "The approximate amount of calories burned by you today is", calBurn, "calories."),
           read = paste("The activity you has done today is READING SOME BOOKS and the duration of your activity is", duration, "minutes",
                        "The approximate amount of calories burned by you today is", calBurn, "calories."),
           walk = paste("The activity you has done today is WALKING and the duration of your activity is", duration, "minutes",
                        "The approximateamount of calories burned by you today is", calBurn, "calories."),
           jog = paste("The activity you has done today is JOGGING and the duration of your activity is", duration, "minutes",
                       "The approximate amount of calories burned by you today is", calBurn, "calories."),
           sports = paste("The activity you has done today is PLAYING SPORTS and the duration of your activity is", duration, "minutes",
                          "The approximate amount of calories burned by you today is", calBurn, "calories"),
           workout = paste("The activity you has done today is DOING SOME WORKOUT and the duration of your activity is", duration, "minutes.",
                           "The approximate amount of calories burned by you today is", calBurn, "calories.")
           )
    
    
  })
  
  ## ---------------------------------------------------------------------------------------------------------------------------
  # This code here will show latest 7 days of users calories burned by the exercise they done
  
  output$plot_caloriesBurned <- renderPlot({
    
    # To make sure the day is in it's order and not alphabetical order
    testBurned$DAY <- factor(testBurned$DAY, levels=unique(testBurned$DAY)) 
    
    ggplot(testBurned, aes(x = DAY, y = BURNED, group = 1)) +
      geom_point() +
      geom_line(color = "#FF0000", size = 1) +
      theme_ipsum() +
      ggtitle("Last 7 Days of Total Calories Burned")
    
  })
  
  ## ---------------------------------------------------------------------------------------------------------------------------
  # This code here will show calories consumed, calories burned and users weight of the last 7 days
  
  output$progress <- renderPlot({
    
    totalData <- mutate(testCalories, BURNED = testBurned$BURNED, WEIGHT = testWeight$WEIGHT)
    
    # To make sure the day is in it's order and not alphabetical order
    totalData$DAY <- factor(totalData$DAY, levels=unique(totalData$DAY))
    
    ggplot(totalData, aes(x = DAY, group = 3 )) +
      geom_point(aes(y = CALORIES)) +
      geom_point(aes(y = BURNED)) +
      geom_point(aes(y = WEIGHT * 40)) +
      geom_line(aes(y = CALORIES), color = "green", size = 1, linetype = 1) +
      geom_line(aes(y = BURNED), color = "red", size = 1, linetype = 2) +
      geom_line(aes(y = WEIGHT * 40), color = "blue", size = 1, linetype = 3) +
      
      scale_linetype(' ') +
      
      scale_y_continuous(name = "Calories",
        
        sec.axis = sec_axis(~./40, name = "Weight (kg)")
        
      ) +
      theme_ipsum() +
      theme(
        legend.position = c(1, 1),
        legend.justification = c(1, 1),
        legend.background = element_rect(fill = "white", colour = "black"),
        plot.title = element_text(
        size = rel(1.2), lineheight = .9,
        family = "Calibri", face = "bold", colour = "brown"
      )) + 
      ggtitle("Your Progress Overall Graph")
    
    
    
  })
  
  ## ---------------------------------------------------------------------------------------------------------------------------
  

})
