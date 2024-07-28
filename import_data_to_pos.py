import pandas as pd
from sqlalchemy import create_engine

# Define the file path to your Excel file
excel_file_path = r'E:\DOWNLOADS_G\Tự học\DA momo\Test_momo\MoMo Talent 2024_DA_Case Study Round_Questions.xlsx'

# Read the Excel file
xls = pd.ExcelFile(excel_file_path)

# Define your PostgreSQL credentials
postgres_user = 'postgres'
postgres_password = 'thanhtin'
postgres_host = 'localhost'
postgres_port = '5432'
postgres_db = 'Momo'

# Create a connection string
connection_string = f'postgresql://{postgres_user}:{postgres_password}@{postgres_host}:{postgres_port}/{postgres_db}'

# Create a SQLAlchemy engine
engine = create_engine(connection_string)

# Loop through each sheet and import the data
for sheet_name in xls.sheet_names:
    # Read each sheet into a DataFrame
    df = pd.read_excel(excel_file_path, sheet_name=sheet_name)
    
    # Define the table name based on the sheet name
    table_name = sheet_name.replace(' ', '_')  # Replace spaces with underscores for SQL compatibility
    
    # Insert the data into the PostgreSQL table
    df.to_sql(table_name, engine, if_exists='replace', index=False)
    
    print(f"Data from sheet '{sheet_name}' imported successfully into table '{table_name}'.")

print("All data imported successfully.")