library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Health and Fitness Tracker"),

    sidebarLayout(
        sidebarPanel(
          
          # Prompting the user to enter their self information such as weight, height, age and gender.
          h3("Please enter your weight, height, age and gender below"),
          numericInput("weight", "Your Weight(kg) : ", value=60, min=1, max=1000, step=1),
          numericInput("height", "Your Height(cm) :", value=170, min=1, max=300, step=1),
          sliderInput("sliderAge", "Your Age : ", 0, 100, 30),
          radioButtons("gender", "Your Gender : ", choices=list("Male"=1, "Female"=2), selected=1),
          
          # Prompting the user to enter what food they eaten today. And what kind of exercise they wanted to do with duration
          h3("Please enter the food at the quantity of the food you consumed today"),
          
          # Prompting the user to enter type of activity and its duration
          h3("Please choose your activity and the duration of your activity"),
          radioButtons("activityChoose", "Activity (Choose one) : ",
                       choices=list("Watching TV"=1, "Reading Book"=2, "Walking"=3, "Jogging"=4, "Playing Sports"=5, "Workout"=6), selected=1),
          sliderInput("activityDuration", "Time of Activity (Minutes) : ", 0, 240, 30),
          
        ),
        

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot")
        )
    )
))
