library(shiny)
library(DT)

server <- function(input, output, session) {
  leaderboard_df <- reactivePoll(
    intervalMillis = GOOGLE_SHEETS_POLL_SECS * 1000,
    session = session,
    checkFunc = read_sheets_df,
    valueFunc = read_sheets_df
  )

  output$leaderboard_dt <- DT::renderDataTable({
    leaderboard_df()
  })
}
