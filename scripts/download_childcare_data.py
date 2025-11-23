import requests
import pandas as pd
import os

url = "https://data.cityofnewyork.us/resource/dsg6-ifza.csv?$limit=50000"
os.makedirs("../data", exist_ok=True)

df = pd.read_csv(url)
df.to_csv("../data/nyc_childcare_inspections_raw.csv", index=False)

print("Download completed → ../data/nyc_childcare_inspections_raw.csv")

