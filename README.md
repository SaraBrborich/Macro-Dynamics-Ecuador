# Economic Analysis: Money Demand and Real Exchange Rate Determinants

This repository contains the code and analysis for the final project on monetary and fiscal policy, which focuses on two primary topics:

## 1. Money Demand in Ecuador (2001–2023)
- Estimation of long-term and short-term money demand using:
  - Real GDP (`ln_gdp`)
  - Real money supply (`ln_M1`)
  - Annual inflation (`ex_in_r`)
- Statistical analyses include:
  - Dickey-Fuller tests for stationarity
  - Cointegration analysis to assess long-term relationships
  - Regression models for short- and long-term money demand
- **Key Findings**:
  - Long-term money demand is stable, maintaining a consistent growth rate.
  - Short-term money demand exhibits significant volatility, as visualized in CUSUM tests.

## 2. Determinants of Real Exchange Rate
- Analysis of factors influencing Ecuador's real exchange rate, based on an adapted model for small open economies.
- Variables include:
  - Real money supply (`mo_agg`)
  - Economic growth per capita (`ecg_perc`)
  - Relative prices of tradable and non-tradable goods (`TNT`)
  - Interest rate differentials (`in_r_d`)
- **Key Results**:
  - Significant relationships were found between economic growth per capita and the real exchange rate.
  - The analysis highlights dynamic interactions using lagged variables.

## Features
- **Data Sources**:
  - Central Bank of Ecuador (BCE)
  - National Institute of Statistics and Census (INEC)
  - Federal Reserve Economic Data (FRED)
- **Econometric Analysis**:
  - Time-series techniques: unit root tests, cointegration, and dynamic regression models.
  - Visualizations of trends and statistical results.
- **Reproducibility**:
  - All scripts for data preprocessing, statistical testing, and model estimation are included.
  - Results can be replicated and modified for similar analyses.

## References
- Abásolo, E. (2018). *Cálculo de la demanda de dinero en una economía dolarizada*. [Digital Repository - EPN](https://bibdigital.epn.edu.ec/handle/15000/19235)
- Chavez, C. (2020). *Determinants of real exchange rate in Latin America*. [Journal of Developing Economies](https://e-journal.unair.ac.id/JDE/index)
- Kia, A. (2013). *Determinants of the real exchange rate in a small open economy*. [Journal of International Financial Markets](https://doi.org/10.1016/j.intfin.2012.09.001)
