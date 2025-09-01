import matplotlib.pyplot as plt
import statsmodels.api as sm

def run(data):

    print("Starting linear regression model...")
    
    # Extract columns for in/out
    x = data[["age_season", "prev_year_games"]]
    y = data[["total_games"]]

    # Independent variables (add constant for intercept)
    x = sm.add_constant(x)  # adds intercept column

    # Fit the model
    model = sm.OLS(y, x).fit()

    # View summary
    print(model.summary())

    # Predicted values
    y_pred = model.predict(x)

    # Create a scatterplot of predicted games played vs. actual games played
    plt.scatter(y, y_pred)
    plt.plot([y.min(), y.max()], [y.min(), y.max()], 'r--')  # 45° line
    plt.xlabel("Actual Games Played")
    plt.ylabel("Predicted Games Played")
    plt.title("Actual vs Predicted")
    plt.show()
    
    