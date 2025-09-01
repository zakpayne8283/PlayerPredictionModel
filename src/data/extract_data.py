import pandas as pd

def load_data():
    data = pd.read_csv('data/batter_data.csv')

    # Pull our columns
    data = data[[
        'age_season',
        'G_all',
        "G_c_prev",
        "G_1b_prev",
        "G_2b_prev",
        "G_3b_prev",
        "G_ss_prev",
        "G_lf_prev",
        "G_cf_prev",
        "G_rf_prev",
        "G_dh_prev"
        ]]

    # # Drop rows with missing values
    data = data.dropna()

    return data