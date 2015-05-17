library(shiny)
library(ggplot2)
library(dplyr) 
library(lubridate)
library(ggthemes)

## hail hadley

shinyServer <- function(input, output) {
    
    dat <- tbl_df(read.csv("Talk_time - Sheet1.csv", stringsAsFactors = FALSE))
    
    dat <- dat %>%
        mutate(
            start.date = mdy(start.date, tz = "EST"),
            end.date = mdy(end.date, tz = "EST"),
            duration = as.numeric(duration.min / 60),
            duration.min = as.numeric(duration.min),
            mode = factor(mode, levels = c("Skype", "Hangouts")),
            start = ymd_hms(paste(start.date, start.time, sep = " ")),
            end = ymd_hms(paste(end.date, end.time, sep = " "))
        )
    
    output$totaltalk <- renderText({
        
        hours <- round(sum(dat$duration), 2)
        
        one <- paste("In total, we've talked for ", hours, " hours, or ", sep = "")
        two <- paste(round(hours * 60, 2), " minutes!", sep = " ")
        
        paste(one, two, sep = "")
        
    })
    
    output$avgtalk <- renderText({
        avg <- round(mean(dat$duration * 60), 2)
        paste("Across both hangouts and skype, we average about ", avg, " minutes per call.", sep = "")
    })
    
    output$plotfun <- renderPlot({
        
        dates <- input$daterange
        rangestart <- dates[1]
        rangeend <- dates[2]
                
        dat <- filter(dat, start > ymd(rangestart) & end < ymd(rangeend))
        
        calltype <- input$mode
        
        if (calltype == "Just Skype") dat <- filter(dat, mode == "Skype")
        if (calltype == "Just Hangouts") dat <- filter(dat, mode == "Hangouts")        
        
        dat %>%
            ggplot(aes(x = start, y = duration, color = mode)) +
            geom_point(size = 3, pch = 18) +
            geom_line() +
            labs(y = "Duration (hours)", x = "Date/Time range") +
            theme(legend.title = element_blank()) +
            theme_hc() +
            scale_colour_hc()
            
    })
    
    output$breakdown <- renderDataTable({
        
        dates <- input$daterange
        rangestart <- dates[1]
        rangeend <- dates[2]
        
        dat <- filter(dat, start > ymd(rangestart) & end < ymd(rangeend))
        
        calltype <- input$mode
        
        if (calltype == "Just Skype") dat <- filter(dat, mode == "Skype")
        if (calltype == "Just Hangouts") dat <- filter(dat, mode == "Hangouts")        
        
        dat %>%
            group_by(mode) %>%
            summarize(calls = n(), 
                      avg.hrs = round(mean(duration), 2),
                      avg.min = round(mean(duration.min), 2),
                      total.hrs = round(sum(duration), 2),
                      total.min = round(sum(duration.min), 2),
                      min.hours = round(min(duration), 2),
                      max.hours = round(max(duration), 2)
            )
        },
        
        options = list(paging = FALSE, searching = FALSE)
    )
    
    output$hist <- renderPlot({
        
        dates <- input$daterange
        rangestart <- dates[1]
        rangeend <- dates[2]
        
        dat <- filter(dat, start > ymd(rangestart) & end < ymd(rangeend))
        
        calltype <- input$mode
        
        if (calltype == "Just Skype") dat <- filter(dat, mode == "Skype")
        if (calltype == "Just Hangouts") dat <- filter(dat, mode == "Hangouts")        
        
        hist(dat$start, "weeks", freq = TRUE,
             border="#ffffff", col="#999999",
             lwd = 0.4, main = "Calls per week",
             xlab = "Week", ylab = "Number of Calls")
        
    })
}