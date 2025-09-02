import data.field_names as fields

class BaseConfig:

    name = None
    x_fields = None
    y_fields = None
    png_name = None

    def get_x_fields(self):
        if self.x_fields is None:
            raise Exception("Must set input fields.")
        
        return self.x_fields
    
    def get_y_fields(self):
        if self.y_fields is None:
            raise Exception("Must set output fields.")
        
        return self.y_fields
        
class GamesPlayedBasic(BaseConfig):
    
    name = "Age & Games Played Last Year (X) vs. Games Played (Y)"
    png_name = "age_games_played"

    x_fields = [
        fields.age_season,
        fields.g_all_prev
    ]
    y_fields = [
        fields.g_all
    ]

class GamesPlayedAllPositionData(BaseConfig):

    name = "Age & Games Played at each Position (X) vs. Games Played (Y)"
    png_name = "age_pos_games_played"

    x_fields = [
        fields.age_season,
        fields.g_c_prev,
        fields.g_1b_prev,
        fields.g_2b_prev,
        fields.g_3b_prev,
        fields.g_ss_prev,
        fields.g_lf_prev,
        fields.g_cf_prev,
        fields.g_rf_prev,
        fields.g_dh_prev
    ]
    y_fields = [
        fields.g_all
    ]