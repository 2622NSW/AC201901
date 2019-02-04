library(tidyverse)
library(shiny)
ui <- fluidPage(
  titlePanel("Asian Cup Tournament 2019"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "x", label ="Horizontal Axis Choice",
                  choices = c("Game" = "Game", "Referee" ="Referee_Name", "Referee's Country" = "CountryRef", 
                              "Fixture" ="Fixture","Card" = "CardID", "Game State When Card Given"= "GameState",  
                              "Yellow Card" = "YCard", "Player" = "Player", "Player's Country" = "CountryPlayer", 
                              "Red Card" = "Red", "Second Yellow Card" = "2YRed"),
                  selected = "CardID"),
      selectInput(inputId = "y", label ="Vertical Axis Choice",
                  choices = c("Game" = "Game", "Referee" ="Referee_Name", "Referee's Country" = "CountryRef", 
                              "Fixture" ="Fixture","Card" = "CardID", "Game State When Card Given"= "GameState",  
                              "Yellow Card" = "YCard", "Player" = "Player", "Player's Country" = "CountryPlayer", 
                              "Red Card" = "Red", "Second Yellow Card" = "2YRed"),
                  selected = "GameID"),
      selectInput(inputId = "z",
                  label = "Colour",
                  choices = c("Game" = "Game", "Referee" ="Referee_Name", "Referee's Country" = "CountryRef", 
                              "Fixture" ="Fixture","Card" = "CardID", "Game State When Card Given"= "GameState",  
                              "Yellow Card" = "YCard", "Player" = "Player", "Player's Country" = "CountryPlayer", 
                              "Red Card" = "Red", "Second Yellow Card" = "2YRed"),
                  selected = "CardID"),
      checkboxInput(inputId = "show_data",
                    label = "Data Table",
                    value = FALSE)
    ),
    mainPanel(
      plotOutput(outputId = "scatterplot", brush = "plot_brush"),
      DT::dataTableOutput(outputId = "AC" ),
      DT::dataTableOutput(outputId = "ACData")
    )
  )
)
server <- function(input, output) {
  output$ACData <- DT::renderDataTable({
    if(input$show_data){
      DT::datatable(data = df %>% select(1:3),
                    options = list(pageLength = 10),
                    rownames = FALSE)
    }
  })
  output$scatterplot <- renderPlot({
    ggplot(df, aes_string(x=input$x, y = input$y, colour = input$z)) +
      geom_point() +
      theme_minimal()
  })
  output$AC <- DT::renderDataTable({
    brushedPoints(df, brush = input$plot_brush) %>%
      select(Game, Referee_Name, CardID)
  })
}
shinyApp(ui = ui, server = server)