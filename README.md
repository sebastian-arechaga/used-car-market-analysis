# Used Car Market Analysis
## Overview

This project analyzes used car listings from Craigslist (2021 dataset) to identify key factors influencing vehicle pricing, including mileage, model year, and manufacturer trends.

SQL was used for data cleaning, transformation, and exploratory analysis, while Python (Pandas, Seaborn, Matplotlib) was used for visualization and deeper analytical insights.

## Tools & Technologies

- Python: Pandas, NumPy, Matplotlib, Seaborn
- SQL: Data cleaning, transformation, and querying
- Jupyter Notebook: Analysis and visualization
- Git & GitHub: Version control

## Project Structure

```
data/
  ├── interim/
  │   └── vehicles_clean.csv        # Cleaned dataset after initial preprocessing
  └── processed/
      └── vehicles_analysis.csv     # Final analysis-ready dataset used in SQL and Python

scripts/
  └── clean_vehicles.py             # Python script for initial data cleaning (column removal, formatting)

sql/
  ├── vehicles_etl_cleaning.sql     # SQL script to create and clean the vehicles_clean table
  ├── vehicles_analysis_view.sql    # SQL view defining the analysis-ready dataset
  └── vehicles_analysis_queries.sql # SQL queries used for exploratory data analysis

notebooks/
  └── used_car_analysis.ipynb       # Main Jupyter notebook with visualizations and insights

reports/
  └── used_car_analysis.html        # Exported HTML version of the notebook for easy viewing
  ```

## Data Pipeline

1. Raw dataset sourced from Kaggle
2. Initial cleaning performed using Python (`clean_vehicles.py`)
3. Further transformation and validation performed in SQL
4. Analysis-ready dataset created using a SQL view (`vehicles_analysis`)
5. Exploratory data analysis conducted using SQL and Python
6. Visualizations created to identify trends and relationships

## Key Insights

- Price increases with newer model years
- Mileage negatively impacts price, though less at higher mileage levels  
- Luxury brands dominate high price ranges, while mass-market brands dominate listings  
- Geographic price variation exists but remains relatively moderate across states

You can view the full analysis here:

[reports/used_car_analysis.html](reports/used_car_analysis.html)

## Dataset Source

This project uses a dataset from Kaggle:

[Used Cars Dataset](https://www.kaggle.com/datasets/austinreese/craigslist-carstrucks-data)

Note: The raw dataset is not included in this repository due to file size limitations.