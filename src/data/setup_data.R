# TODO: Properly organize this file in the hierarcy
#     it's an R file, it doesn't go with python code...
library(dplyr)
library(Lahman)

core_fields <- c("playerID", "teamID", "lgID", "yearID", "G_all", "G_p",
                 "G_batting")

position_fields <- c("G_c", "G_1b", "G_2b", "G_3b", "G_ss",
                     "G_lf", "G_cf", "G_rf", "G_dh")

# Join the People data to get birth dates
player_data <- Appearances |>
  filter(
    yearID >= 2015,
    yearID != 2020
  ) |>
  inner_join(People, by = "playerID") |>
  select(all_of(core_fields), birthYear, birthMonth, all_of(position_fields))

# Then add that player's age_season
batter_data <- player_data |>
  mutate(
    age_season = ifelse(
      birthMonth >= 7,
      yearID - birthYear - 1,
      yearID - birthYear
    )
  ) |>
  select(all_of(core_fields), age_season, all_of(position_fields)) |>
  mutate(
    # Count games at non-pitcher positions
    non_pitcher_games = G_batting - G_p,
    is_pitcher = case_when(
      G_p >= 1 & non_pitcher_games <= 2 ~ TRUE,
      TRUE ~ FALSE
    )
  ) |>
  select(playerID, teamID, age_season, is_pitcher,
         G_all, all_of(position_fields)) |>
  filter(is_pitcher == FALSE)

batter_data <- batter_data |>
  group_by(playerID, age_season) |>
  summarize(
    across(starts_with("G_"), sum, na.rm = TRUE),
    .groups = "drop"
  ) |>
  group_by(playerID) |>
  arrange(age_season, .by_group = TRUE) |>
  mutate(
    across(
      starts_with(("G_")),
      ~ lag(.x),
      .names = "{.col}_prev"
    )
  ) |>
  ungroup() |>
  select(playerID, age_season, G_all, ends_with("_prev"))

batter_data

write.csv(batter_data, "data/batter_data.csv")