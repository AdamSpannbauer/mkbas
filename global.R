library(shiny)
library(anytime)
library(showtext)

font_add(family = "gosha", "./www/GoshaSans-Regular.ttf")
showtext_auto()

RED <- "#dd4b39"

GOOGLE_SHEETS_URL <- "https://docs.google.com/spreadsheets/d/1KQuqbI2bdVfXJuPeZkuaPulqG0tDx8cNwY9gIa7Tydw/export?format=csv"
GOOGLE_SHEETS_POLL_SECS <- 5

read_sheets_df <- function() {
  og_names <- c(
    "Timestamp", "First.Name.", "Last.Name.", "Primary.Major.",
    "Year.", "Time..1.23.45..", "Character.", "Course.", "Vehicle.",
    "Favorite.Ice.Cream."
  )

  new_names <- c(
    "timestamp", "first_name", "last_name", "major",
    "year", "time", "character", "course", "vehicle",
    "ice_cream"
  )

  # Warning message:
  #   In read.table(...),  :
  #      incomplete final line found by readTableHeader on '...'
  suppressWarnings({
    times_df <- read.csv(GOOGLE_SHEETS_URL)
  })

  names(times_df) <- new_names

  times_df$course <- NULL

  times_df$year <- factor(times_df$year, levels = c("Freshman", "Sophomore", "Junior", "Senior", "Graduate", "Faculty", "Staff"))

  times_df$full_name <- paste(times_df$first_name, times_df$last_name)

  times_df$timestamp <- anytime(times_df$timestamp)

  split_time <- strsplit(times_df$time, ":")

  minutes <- vapply(split_time, `[`, character(1), 1)
  minutes <- as.numeric(minutes)

  times_df$seconds <- vapply(split_time, `[`, character(1), 2)
  times_df$seconds <- 60 * minutes + as.numeric(times_df$seconds)
  times_df$minutes <- times_df$seconds / 60

  times_df$character <- tools::toTitleCase(times_df$character)
  times_df$character_icon <- paste0(
    "MK8_", gsub("[^[:alpha:]]", "", times_df$character), "_Icon.webp"
  )
  times_df$char_icon_html <- paste0(
    '<img src="char-icons/', times_df$character_icon, '", width=50px>'
  )

  times_df$vehicle <- tools::toTitleCase(times_df$vehicle)
  # times_df$course <- tools::toTitleCase(times_df$course)

  return(times_df)
}

format_seconds_ <- function(seconds) {
  integer_part <- floor(seconds)
  fractional_part <- seconds - integer_part

  minutes <- floor(integer_part / 60)
  remaining_seconds <- integer_part %% 60

  formatted_times <- sprintf("%d:%02d", minutes, remaining_seconds)

  decimal_str <- sprintf("%.2f", fractional_part)
  decimal_str <- substr(decimal_str, 2, 4)
  formatted_times <- paste0(formatted_times, decimal_str)

  return(formatted_times)
}

format_seconds <- Vectorize(format_seconds_, vectorize.args = "seconds")

standard_error <- function(x) sd(x) / sqrt(length(x))
mean_and_se <- function(x) c(mean = mean(x), se = standard_error(x))

mean_and_se_bar_plot <- function(df, x, y, reverse_sort = FALSE) {
  summary_df <- aggregate(
    as.formula(paste(y, "~", x)),
    data = df,
    FUN = mean_and_se
  )
  summary_df <- do.call(data.frame, summary_df)

  names(summary_df) <- c(x, paste0(y, ".mean"), paste0(y, ".se"))
  summary_df$ymin <- summary_df[[2]] - summary_df[[3]]
  summary_df$ymax <- summary_df[[2]] + summary_df[[3]]

  summary_df <- summary_df[order(summary_df[[2]]), ]
  if (reverse_sort) {
    summary_df[[1]] <- factor(
      summary_df[[1]],
      levels = rev(summary_df[[1]])
    )
  } else {
    summary_df[[1]] <- factor(
      summary_df[[1]],
      levels = summary_df[[1]]
    )
  }


  p <- ggplot(summary_df, aes_string(x, names(summary_df)[2])) +
    geom_bar(stat = "identity", fill = RED) +
    geom_errorbar(
      aes(ymin = ymin, ymax = ymax),
      color = "white",
      width = .2
    )

  p
}

theme_mk <- function() {
  theme(
    plot.background = element_rect(fill = "black"),
    panel.background = element_rect(
      fill = "#101010",
      linewidth = 0.5,
      linetype = "solid"
    ),
    panel.grid.major = element_line(
      linewidth = 0.5,
      linetype = "solid",
      colour = "#606060"
    ),
    panel.grid.minor = element_line(
      linewidth = 0.25,
      linetype = "solid",
      colour = "#606060"
    ),
    text = element_text(color = "white", family = "gosha", size = 20),
    axis.text = element_text(color = "white", size = 13)
  )
}
