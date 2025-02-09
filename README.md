# Profitability of Expert Forecasts of Interest Rates
This repository contains scripts and data used for my master's thesis ***Worth the Cost? A Trading-Based Profitability Analysis of Expert Forecasts of US Treasury Yields***, which was written as part of the Master in Banking and Finance at the University of St. Gallen. 

## Contents
This Github Repository contains:
- **Internet Appendix**: A PDF file titled Internet_Appendix.pdf containing detailed results, including the risk and return profiles for all combinations of maturity, forecast horizon, financial instrument, and strategy.
-	**Code**: A folder named Scripts/ with all scripts used for data analysis and visualisation. The scripts are written in Python and R and include detailed comments for reproducibility.
- **Data**: A folder named Data/ with all datasets used in this thesis. This folder includes the raw data as well as files with the results.

---
## Installation

To run the scripts in this repository, install the required **Python** and **R** packages.

### Python Packages
To ensure that all Jupyter Notebooks run smoothly, install the necessary Python packages using the following command in Python:
```bash
pip install pandas numpy fredapi matplotlib statsmodels scikit-learn empyrical scipy
```

### R Packages Installation

To ensure that all R scripts run smoothly, install the necessary R packages using the following command in R:

```r
install.packages(c("PeerPerformance", "dplyr", "writexl"))
```
---
## Order of Execution

To reproduce the results of the thesis, download this repository and run the notebooks/scripts in the following order (more details in individual notebooks):

1. **Scripts in Folder Data**: Run the notebooks in the folder data to clean the raw data.
   - FRED/
      - `TreasuryYield.ipynb`
    - Treasury Department/
        - `YieldCurve.ipynb`
    - Reuters/
        - ETF/
            - `IEF_ETF.ipynb`
            - `SHY_ETF.ipynb`
        - Forecast/10Y2Y Treasury/
            - `3M_Horizon.ipynb`
            - `6M_Horizon.ipynb`
            - `12M_Horizon.ipynb`
        - Futures
            - `Futures.ipynb`

2. **Alternative Forecasts**: To calculate the alternative forecasts and to determine the best forecast of the individual forecasters.
    - `AlternativeForecasts.ipynb`
    - `Individual Forecaster.ipynb`

3. **Descriptive Data Analysis**: To calculate descriptive data used in Sections 5.1 and 5.2 of the thesis.
    - `DirectionFinancialInstrument.ipynb`
    - `ErrorMeasures.ipynb`

4. **Trading Strategies**: This folder and subfolder contain 12 scripts in total, in which the trading strategies are implemented (regular and robustness checks with MOVE index). The results of these scripts are CSV files with quarterly returns of the different types of forecasts for the different strategies.

5. **Results**: In this folder, there are two scripts (one for the regular analysis, one for the robustness check), where the risk and return measures of the different trading strategies (discussed in Section 5.3 of the thesis), are computed based on the quarterly returns.
    - `Risk and Return Measures.ipynb`
    - `Risk and Return Measures - MOVE.ipynb`

6. Results/**Statistical Tests**: In this folder, there are three Jupyter Notebooks (Python) and two R-Scripts, where the statistical tests performed in the thesis are conducted.
    - `T-TestReturns.ipynb`
    - `T-TestReturns - MOVE.ipynb`
    - `SpearmanRank.ipynb`
    - `SharpeTest.R`
    - `SharpeTest - MOVE.R`
  
  ---
