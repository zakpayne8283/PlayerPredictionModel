import matplotlib.pyplot as plt
import statsmodels.api as sm

import models.configs as configs

def run(data):

    print("Starting linear regression models...")

    models_to_run = [
        configs.GamesPlayedBasic,
        configs.GamesPlayedAllPositionData,
        configs.GamesPlayedVsPARate
    ]
    
    for model in models_to_run:
        print(f"Running model: {model.name}")

        x = data[model.x_fields]
        y = data[model.y_fields]

        # Independent variables (add constant for intercept)
        x = sm.add_constant(x)  # adds intercept column

        # Fit the model
        fit_model = sm.OLS(y, x).fit()

        # View summary
        print(fit_model.summary())

        # Predicted values
        y_pred = fit_model.predict(x)

        # Clear matplotlib
        plt.figure()

        # Create a scatterplot of predicted games played vs. actual games played
        plt.scatter(y, y_pred)
        plt.plot([y.min(), y.max()], [y.min(), y.max()], 'r--')  # 45° line
        plt.xlabel("Actual Games Played")
        plt.ylabel("Predicted Games Played")
        plt.title(model.name)
        plt.savefig(f"outputs/{model.png_name}.png")
        
    