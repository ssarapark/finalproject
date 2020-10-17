#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(tidyverse)
library(dplyr, warn.conflicts = FALSE)
library(ggforce)

oecd <- read_csv("DP_LIVE_14102020222633846.csv", 
                 col_types = cols(LOCATION = col_character(),
                                   INDICATOR = col_character(),
                                   SUBJECT = col_character(),
                                   MEASURE = col_character(),
                                   FREQUENCY = col_character(),
                                   TIME = col_double(),
                                   Value = col_double(),
                                   'Flag Codes' = col_logical())) %>% 
    select(LOCATION, SUBJECT, TIME, Value) 


ui <- navbarPage(
    "Final Project Title",
    tabPanel("Background", 
             titlePanel("Introduction")),
    tabPanel("Model",
             fluidPage(
                 selectInput("x", "X variable", choices = names(oecd)),
                 selectInput("y", "Y variable", choices = names(oecd)),
                 selectInput("geom", "geom", c("point", "column", "jitter")),
                 plotOutput("plot")
             )),
    tabPanel("Discussion",
             titlePanel("Discussion Title"),
             p("Tour of the modeling choices you made and 
              an explanation of why you made them")),
    tabPanel("About", 
             titlePanel("About"),
             h3("Project Background and Motivations"),
             p("I am still in the process of specifying my final project for 
               Gov50. I know I want my project to be about gender violence 
               around the world, more specifically in Latin America. I am 
               interested in the relationship between reproductive rights 
               and gender-based violence, and am also interested in this 
               relationship with rates of femicide. I am interested in 
               exploring this because of a research paper I did on the 
               influence of gangs in El Salvador, and came across substantial 
               information regarding femicide and gender-based violence. I am 
               still in the process of collecting more data, as the data I 
               have currently is broader in that it takes covers all kinds of 
               violence against women or is too broad from a country scope. "),
             h3("Data"),
             h4("Dataset 1: Violence Against Women, Attitudes towards violence, 
                Percentage, 2014 or latest available"),
             p("I am still in the process of cleaning and gathering data. 
               I plan to use dataset 1 by selecting specific countries, type 
               of violence, and measure of violence.", a("OECD data", 
                 href = 
                "https://data.oecd.org/inequality/violence-against-women.htm")),
             h4("Dataset 2: Proportion of ever-partnered women and girls aged
                15 years and older subjected to physical, sexual or 
                psychological violence by a current or former intimate partner
                in the previous 12 months, by form of violence and by age"),
             p("I am still in the process of cleaning and gathering data. I plan
               to use dataset 2 by selecting specific regions, age range of
               victims, type of violence, and measure of violence.", 
               a("UN data", 
                 href = 
                     "- https://genderstats.un.org/#/downloads")),
             h3("About Me"),
             p("My name is Sara, I am a sophomore in Currier and 
             I am on the Women's Varsity Basketball Team.
             I am a Government concentrator with a secondary in Economics."),
             h3("Contact"),
             p("Don't hesitate to contact me with any questions. 
               My email is spark@college.harvard.edu"),
             p("My githube repo for this project can be found", a("here.",
                 href = "https://github.com/ssarapark/finalproject.git"),
               "Please feel free to take a look!")))
           

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    plot_geom <- reactive({
        switch(input$geom,
               point = geom_point(alpha = 0.5),
               column = geom_col,
               jitter = geom_jitter()
        )
    })
    
    output$plot <- renderPlot({
        ggplot(oecd, aes(.data[[input$x]], .data[[input$y]], 
                         label = LOCATION)) +
            plot_geom()
    }, res = 96)
}

oecd %>% 
    ggplot(aes(x = SUBJECT, y = Value)) +
    geom_text(aes(label = LOCATION))

# Run the application 
shinyApp(ui = ui, server = server)
