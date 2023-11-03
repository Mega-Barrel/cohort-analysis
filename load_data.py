import os
import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine

load_dotenv()

database = os.environ.get('database')
user = os.environ.get('user')
password = os.environ.get('password')
host = os.environ.get('host')
port = os.environ.get('port')

pg_connection_engine = create_engine(f"postgresql://{user}:{password}@{host}:{port}/{database}")

print('Started reading Excel sheet')
excel_data = pd.read_excel(
    'data/Online Retail.xlsx', 
    sheet_name='Online Retail'
)
print('Finished reading Excel sheet')

print('Started Pandas to_sql operation')
excel_data.to_sql(
    'test_store_data', 
    pg_connection_engine, 
    if_exists='replace',
    index=False
)
print('Finished Pandas to_sql operation')
