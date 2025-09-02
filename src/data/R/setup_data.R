# ---- Libraries ----
library(dplyr)
library(Lahman)

names(Batting)

# ---- Field definitions ----

# - Game Rules Definitions -

position_fields <- c(
  "G_c", "G_1b", "G_2b", "G_3b", "G_ss",
  "G_lf", "G_cf", "G_rf", "G_dh", "G_p"
)

# - Lahman Fields Pulled -

# Data from People table
people_fields <- c("playerID", "birthYear", "birthMonth")
# Data from Appearances table
appearances_fields <- c(
  "playerID", "yearID", "teamID", "G_all", "G_batting", all_of(position_fields)
)
# Data from Batting table
batting_fields <- c("playerID", "yearID", "teamID", "AB", "BB", "HBP", "SF")

# ---- Functions ----

# Filters years for data
filter_valid_years <- function(data) {
  data |>
    filter(data$yearID >= 2015, data$yearID != 2020)
}

# ---- Step 1. Data prep ----

# Select all data from People that we need
player_data <- People |>
  select(all_of(people_fields))

# Select all data from Appearances that we need
appearances_data <- Appearances |>
  filter_valid_years() |>
  select(all_of(appearances_fields))

# Select all data from Batting that we need
batting_data <- Batting |>
  filter_valid_years() |>
  select(all_of(batting_fields))

# ---- Step 2. Basic Data Mutation(s) ----

# Tidy all double entry years for each player
appearances_data <- appearances_data |>
  group_by(playerID, yearID) |>
  summarize(
    across(starts_with("G_"), ~ sum(.x, na.rm = TRUE)), .groups = "drop"
  )

batting_data <- batting_data |>
  group_by(playerID, yearID) |>
  summarize(
    across(.cols = where(is.numeric), .fns  = ~ sum(.x, na.rm = TRUE)),
    .groups = "drop"
  ) |>
  mutate(PA = AB + BB + HBP + SF) |>
  select(-AB, -BB, -HBP, -SF)

# ---- Step 3. Table Joins ----

# Absorb People into Appearances
appearances_data <- appearances_data |>
  inner_join(player_data, by = "playerID") |>
  # Also calculate the age_season while we're here
  mutate(
    age_season = if_else(
      birthMonth >= 7,
      yearID - birthYear - 1,
      yearID - birthYear
    )
  ) |>
  select(-birthYear, -birthMonth)

# Join Batting + filter for our basic raw output data
output_data_raw <- appearances_data |>
  inner_join(batting_data, by = c("playerID", "yearID")) |>
  filter(
    PA > G_batting, # Exclude an "career pinch-hitters"
    G_p <= 3,       # Max 3 games pitched - allows for pos players to pitch
    G_p < G_batting, # Must hit more than pitch
  ) |>
  select(-G_batting)

# ---- Step 4. Calculate Values ----

# Get all of last season's values
output_data <- output_data_raw |>
  group_by(playerID) |>
  arrange(age_season, .by_group = TRUE) |>
  mutate(
    across(matches("^G_|^PA$"), ~ lag(.x), .names = "{.col}_prev")
  ) |>
  select(-all_of(position_fields), -PA, -G_p_prev)

# ---- Save ----
write.csv(output_data, "data/batter_games_data.csv", row.names = FALSE)