import pandas as pd

df = pd.read_csv("vehicles.csv")

# Drop unwanted columns
df = df.drop(columns=[
    "url",
    "region_url",
    "image_url",
    "description",
    "county"
])

# Fix numeric columns
df["year"] = pd.to_numeric(df["year"], errors="coerce").astype("Int64")
df["price"] = pd.to_numeric(df["price"], errors="coerce").astype("Int64")
df["odometer"] = pd.to_numeric(df["odometer"], errors="coerce").astype("Int64")

# Save cleaned CSV
df.to_csv("vehicles_clean.csv", index=False)