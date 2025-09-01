import pandas as pd

def load_data():
    data = pd.read_csv('data/batter_data.csv')

    # Pull our columns
    data = data[['age_season', 'total_games', 'prev_year_games']]

    # # Drop rows with missing values
    data = data.dropna()

    return data