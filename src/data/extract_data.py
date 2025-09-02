import pandas as pd

import data.field_names as fields

def load_data():
    data = pd.read_csv('data/batter_data.csv')

    # Pull our columns
    data = data[fields.get_all()]

    # # Drop rows with missing values
    data = data.dropna()

    return data