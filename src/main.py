import data.extract_data as extract_data
import models.linear_regression as lm

if __name__ == "__main__":

    print("=====")
    print("Python Script Starting...")

    player_data = extract_data.load_data()

    print("*---*")
    print("Running models...")
    
    lm.run(player_data)