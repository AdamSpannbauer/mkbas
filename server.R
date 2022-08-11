library(shiny)
library(DT)

server <- function(input, output, session) {
  google_sheets_df <- reactivePoll(
    intervalMillis = GOOGLE_SHEETS_POLL_SECS * 1000,
    session = session,
    checkFunc = read_sheets_df,
    valueFunc = read_sheets_df
  ) # reactivePoll

  leaderboard_df <- reactive({
    display_cols <- c("name", "major", "time")
    display_col_names <- c("Name", "Major", "Time")

    # min time per name + major
    leaderboard_df <- aggregate(
      seconds ~ name + major,
      data = google_sheets_df(),
      FUN = min
    )

    # Get back demo info and sort
    leaderboard_df <- merge(
      leaderboard_df,
      google_sheets_df(),
      by = c("name", "major", "seconds")
    )
    leaderboard_df <- leaderboard_df[order(leaderboard_df$seconds), ]

    # Pretty up
    leaderboard_df <- leaderboard_df[, display_cols]
    names(leaderboard_df) <- display_col_names
    rownames(leaderboard_df) <- NULL

    leaderboard_df
  })

  output$leaderboard_dt <- DT::renderDataTable(
    leaderboard_df(),
    options = list(
      iDisplayLength = 50,
      bLengthChange = 0
    )
  ) # renderDataTable
}
