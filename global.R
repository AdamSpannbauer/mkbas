library(shiny)
library(showtext)

font_add(family = "gosha", "./www/GoshaSans-Regular.ttf")
showtext_auto()

RED <- "#dd4b39"

GOOGLE_SHEETS_URL <- "https://docs.google.com/spreadsheets/d/1wE1edE_splonZxdRVh_hIu4-ZyR1w4XmGVapl9kSzTc/export?format=csv"
GOOGLE_SHEETS_POLL_SECS <- 5

TIME_STAMP_FORMAT <- "%I:%M:%S %p"

read_sheets_df <- function() {
  # Warning message:
  #   In read.table(...),  :
  #      incomplete final line found by readTableHeader on '...'
  suppressWarnings({
    times_df <- read.csv(GOOGLE_SHEETS_URL)
  })

  times_df$timestamp <- as.POSIXlt(times_df$timestamp, format = TIME_STAMP_FORMAT)

  split_time <- strsplit(times_df$time, ":")

  minutes <- vapply(split_time, `[`, character(1), 1)
  minutes <- as.numeric(minutes)

  times_df$seconds <- vapply(split_time, `[`, character(1), 2)
  times_df$seconds <- 60 * minutes + as.numeric(times_df$seconds)

  times_df$controller <- tools::toTitleCase(times_df$controller)
  times_df$character <- tools::toTitleCase(times_df$character)
  times_df$car <- tools::toTitleCase(times_df$car)

  return(times_df)
}

standard_error <- function(x) sd(x) / sqrt(length(x))
mean_and_se <- function(x) c(mean = mean(x), se = standard_error(x))

theme_mk <- function() {
  theme(
    plot.background = element_rect(fill = "black"),
    panel.background = element_rect(
      fill = "#101010",
      size = 0.5,
      linetype = "solid"
    ),
    panel.grid.major = element_line(
      size = 0.5,
      linetype = "solid",
      colour = "#606060"
    ),
    panel.grid.minor = element_line(
      size = 0.25,
      linetype = "solid",
      colour = "#606060"
    ),
    text = element_text(color = "white", family = "gosha", size = 20),
    axis.text = element_text(color = "white", size = 13)
  )
}
