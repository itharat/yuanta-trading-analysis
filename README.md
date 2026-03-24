# 📊 Trading Analytics Dashboard: Thai Securities Co., Ltd.

**Developed by:** Napatcha Itharat  
**Live Demo:** [https://napatchaith.shinyapps.io/yuanta_sec/](https://napatchaith.shinyapps.io/yuanta_sec/)

## 🚀 Project Overview
This project provides management with critical visibility into business performance, client behavior, and trading operations. It transforms raw datasets into a strategic diagnostic tool.

## 🛠 My Approach
1. **Exploratory Data Analysis (Python):** Used `date_exploration.py` to perform initial data cleaning and calculate IQR-based outliers to identify "Whale" clients.
2. **Interactive Dashboard (R Shiny):** Developed a multi-tab application focusing on Market Dominance, Regional Segmentation, and Outlier Analysis.
3. **Deployment:** Hosted via `shinyapps.io` for real-time stakeholder access.

## 📈 Key Business Insights
* **Southern Region Growth:** The South has emerged as the primary revenue driver, outperforming Bangkok in retail client concentration and consistency.
* **The "Hidden Whale" Opportunity:** Retail segment analysis revealed "top whisker" clients trading at Institutional volumes—a key upselling target.
* **Sector Risk:** Over 50% of trade value is concentrated in Banking and Energy, indicating high sensitivity to specific market sectors.

## 📁 Repository Structure
* `ui.R` & `server.R`: The core R Shiny application logic.
* `date_exploration.py`: Python script used for initial data profiling and outlier logic.
* `*.csv`: All 5 primary datasets (Transactions, Clients, Stock Master, Market Data, Commission Rates).
* `data.Rproj`: R Project configuration.