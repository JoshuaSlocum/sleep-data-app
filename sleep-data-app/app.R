#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(readr)
library(dplyr)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(

   # Application title
   titlePanel("Sleep Data Analysis"),

   sidebarLayout(
      sidebarPanel(
        fileInput('sleep_data_raw'
                  ,'Upload Your Sleep Data CSV'
                  ,accept = c('text/csv'
                              ,'text/comma-separated-values'
                              ,'text/plain'
                              ,'.csv')
                  )
      ),

      mainPanel(
        plotOutput("plot_a")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {

  # Import the sleep data
   raw_data <- reactive({
    data_file <- input$sleep_data_raw
    if (is.null(data_file)) {return(NULL)}

    return(readr::read_delim(data_file$datapath, delim = ";"))
    })

  # Output Scatter Plot of time vs steps
  output$plot_a <- renderPlot({
    if (is.null(raw_data())) {return(NULL)}
    raw_data() %>% ggplot(aes(`Time in bed`, `Activity (steps)`)) + geom_point()
  })


}

# Run the application
shinyApp(ui = ui, server = server)

