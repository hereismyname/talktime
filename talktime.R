library(dplyr)
library(lubridate)
library(ggplot2)

dat <- tbl_df(read.csv("Talk_time - Sheet1.csv", stringsAsFactors = FALSE))

dat <- dat %>%
    mutate(
        start.date = mdy(start.date, tz = "EST"),
        end.date = mdy(end.date, tz = "EST"),
        duration = duration.min / 60,
        mode = factor(mode, levels = c("Skype", "Hangouts")),
        start = ymd_hms(paste(start.date, start.time, sep = " ")),
        end = ymd_hms(paste(end.date, end.time, sep = " "))
        )

num.calls <- data.frame(table(dat$start.date)) %>%
    mutate(Var1 = ymd(Var1))
names(num.calls) <- c("date", "freq")

dat %>%
    filter(start > ymd("2015-01-01")) %>%
    ggplot(aes(x = start, y = duration, color = mode)) +
    geom_line(size = 1.2) + geom_point(size = 3)

#' Long-term goal is to turn this into a shiny app.
#' This plot call at the bottom will likely be the foundation.
#' I'd like to make it possible for users to pick dates they want to filter.
#' Some kind of function needs to be written to enable that.

dat %>%
    group_by(mode) %>%
    summarize(calls = n(), 
              total.hours = round(sum(duration), 0),
              avg.hours = round(mean(duration), 2),
              min.hours = round(min(duration), 2),
              max.hours = round(max(duration), 2)
              )