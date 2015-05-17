library(shiny)

shinyUI(fluidPage(
    titlePanel("How much do we talk?"),
    sidebarLayout(
        sidebarPanel(
            
            p("So, after you left in January, I decided to start keeping
              track of the moments we got to sit and talk. I guess I didn't want to take for
              granted how easy it is when we're together, and I kind of wanted to see how things
              worked when there's some water or dirt between us. I think it's
              kind of cool to see how the number of calls change each week, and to see
              how long we're talking, so I hope you like playing with it."),
            
            p("In the end, I'm surprised we've only spent a week talking to each other.
              I'm looking forward to bringing those numbers up when I see you soon!"),
            
            dateRangeInput("daterange", "Pick some days:",
                           start = "2014-06-18",
                           end = "2015-05-11",
                           format = "yy/mm/dd",
                           separator = " to "),
            
            selectInput("mode", "Hangouts, Skype or both?",
                        choices = c("Just Hangouts", "Just Skype",
                                    "I wanna see both"),
                        selected = "I wanna see both"),
            
            p("Ah, one note about the number of calls being recorded: they include
              all the times one of us started a call, so all the times the internet
              and robots have been mad are in here too.")
            
        ),
        mainPanel(
            textOutput("totaltalk"),
            textOutput("avgtalk"),
            plotOutput("plotfun"),
            dataTableOutput("breakdown"),
            plotOutput("hist")
          )
    )
))