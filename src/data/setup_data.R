library(dplyr)
library(Lahman)

player_data <- Appearances |>
  filter(
    yearID >= 2015,
    yearID != 2020
  ) |>
  inner_join(People, by = "playerID") |>
  select(
    playerID,
    teamID,
    lgID,
    yearID,
    G_all,
    G_p,
    GS,
    G_batting,
    G_defense,
    birthYear,
    birthMonth
  )

# Add then select out just the data we need
batter_data <- player_data |>
  mutate(
    age_season = ifelse(
      birthMonth >= 7,
      yearID - birthYear - 1,
      yearID - birthYear
    )
  ) |>
  select(
    playerID,
    yearID,
    teamID,
    G_all,
    G_p,
    GS,
    G_batting,
    G_defense,
    age_season
  ) |>
  mutate(
    # Count games at non-pitcher positions
    non_pitcher_games = G_batting - G_p,
    is_pitcher = case_when(
      G_p >= 1 & non_pitcher_games <= 2 ~ TRUE,
      TRUE ~ FALSE
    )
  ) |>
  select(playerID, teamID, age_season, non_pitcher_games, is_pitcher) |>
  filter(is_pitcher == FALSE)

batter_data <- batter_data |>
  group_by(playerID, age_season) |>
  summarize(total_games = sum(non_pitcher_games, na.rm = TRUE)) |>
  group_by(playerID) |>
  arrange(age_season, .by_group = TRUE) |>
  mutate(prev_year_games = lag(total_games)) |>
  ungroup()

write.csv(batter_data, "data/batter_data.csv")