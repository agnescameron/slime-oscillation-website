library(shiny)
library(jsonlite)



ui <- fluidPage(
  htmlTemplate("www/index.html")
)


server <- function(input, output, session) {
  observe({
    session$sendCustomMessage(type = "loadJSON", 
                              message = read_json("test.json"))
    }) 
  
}

shinyApp(ui, server)