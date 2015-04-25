# author: Pilot Gtec
# created: 23 April 2015

library(shiny)

shinyUI(
    pageWithSidebar(
        headerPanel("Word Prediction App"),
        sidebarPanel(br(),
            h4("Instructions"),
            p("Type a word or phrase in the text box on the main panel (right).
              Hit the *Next Word* button to generate a prediction of word(s)",
              " that would highly likely come after the last word in the", 
              " statement provided."), 
            br(),
            strong("Output"), 
            p("A single word prediction and",
              " a list of at most five top next words including the single",
              " word predicted"),
            strong("Filtering Profane Words"), 
            p("The app replaces predicted profane words",
              " with the placeholder puppy*.")

        ),                           
        mainPanel(
            br(),
            textInput("myStatement", label="Your Statement", value=""),
            actionButton("predictButton", "Next Word"),
            br(),
            br(),
            strong("Single Word (Prediction):"),
            h2(textOutput("singleword")),
            em(textOutput("comment")),
            br(),
            br(),
            strong("Predited Statement: Your Statment + Predicted Single Word"),
            h3(textOutput("predstatement")),
            br(),
            br(),
            strong("Top predicted nextwords:"),
            h4(textOutput("predictions")),
            hr()
        )

    )
)