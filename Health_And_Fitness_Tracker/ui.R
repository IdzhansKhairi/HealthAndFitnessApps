library(shiny)
library(shinydashboard)
library(rvest)
library(dplyr)
library(DT)
library(ggplot2)

shinyUI(fluidPage(
    
  dashboardPage(
    
    # Application title
    dashboardHeader(title = h4("Health and Fitness Tracker")),
    
    # Application side bar
    dashboardSidebar(
        
      sidebarMenu(
        menuItem("Personal Information", tabName = "dashboard", icon = icon("user"),
                 
                 textInput("userName", "Name : ", value = "Your Name Here"),
                 numericInput("userWeight", "Weight (kg) : ", value = 60, min = 1, max = 1000, step = 1),
                 numericInput("userHeight", "Height (cm) : ", value = 170, min = 1, max = 300, step = 1),
                 sliderInput("userAge", "Age : ", 20, 100, 30),
                 radioButtons("userGender", "Gender", choices = list("Male" = "male", "Female" = "female"), selected = "male"),
                 submitButton(text = "Apply Changes")),
        
        menuItem("Food Taken", tabName = "widgets", icon = icon("utensils"),
                 
                 numericInput("totalCalories", "Total Calories Consumed (Refer Table) : ", value = 0, min = 0, max = 100000, step = 1),
                 submitButton(text = "Apply Changes")
                 
                ),
        
        menuItem("Acivitiy Done", tabName = "activity", icon = icon("running"),
                 
                 radioButtons("activityChoose", "Activity (Choose one) : ",
                              choices = list("Watching TV" = "tv", "Reading Book" = "read", "Walking" = "walk", 
                                           "Jogging" = "jog", "Playing Sports" = "sports", "Workout" = "workout"), 
                                           selected = "tv"),
                 
                 sliderInput("activityDuration", "Time of Activity (Minutes) : ", 0, 240, 30),
                 submitButton(text = "Apply Changes"))
        
      )
        
    ),
    
    # Application main bar
    dashboardBody(
      
      fluidRow(
        
        infoBoxOutput("usersName"),
        infoBoxOutput("usersWeight"),
        infoBoxOutput("usersHeight")
        
      ),
      fluidRow(
        
        infoBoxOutput("usersAge"),
        infoBoxOutput("usersGender"),
        infoBoxOutput("usersBMI")
        
      ),
      fluidRow(
        
        tabBox(
          title = tagList(shiny::icon("hamburger"), "Calories Consumed"),
          tabPanel(title = "Food List Table",
                   div(DT::DTOutput("food_table"), style = "font-size: 80%;")),
          
          tabPanel(title = "Calories Consumed",
                   strong(h2(textOutput("gendercalory"))),
                   div(dataTableOutput("caloryneed"), style = "font-size: 80%"),
                   strong(h4(textOutput("dailycalorie")))),
          
          tabPanel("Calories Consumed Graph", 
                   plotOutput("plot_caloriesPercent"))
        ),
        
        tabBox(
          title = tagList(shiny::icon("fire"), "Calories Burned"),
          tabPanel(title = "Exercise List Table",
                   div(DT::DTOutput("exercise_table"), style = "font-size: 80%;")),
          tabPanel(title = "Calories Burned",
                   strong(h2("Your Activity Today")),
                   uiOutput("exerciseImg"),
                   strong(h4(textOutput("calBurnedText")))),
          tabPanel(title = "Calories Burned Graph",
                   plotOutput("plot_caloriesBurned"))
        )
        
      ),
      fluidRow(
        
        box(title = "Your Progress So Far", status = "success", solidHeader = TRUE, width = 12, collapsible = TRUE,
            plotOutput("progress")
            )
        
      )
    )
  )
))
