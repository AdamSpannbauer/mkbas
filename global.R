library(anytime)

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
  times_df$minutes <- vapply(split_time, `[`, character(1), 1)
  times_df$seconds <- vapply(split_time, `[`, character(1), 2)

  times_df$minutes <- as.numeric(times_df$minutes)
  times_df$seconds <- as.numeric(times_df$seconds)

  times_df$time <- NULL

  return(times_df)
}
