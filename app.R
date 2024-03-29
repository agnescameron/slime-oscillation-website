library(shiny)
library(jsonlite)



ui <- fluidPage(
  htmlTemplate("www/index.html")
)


server <- function(input, output, session) {
  observe({
    session$sendCustomMessage(type = "loadJSON", 
                              message = read_json("oscillations.json"))
    }) 
  
}

shinyApp(ui, server)