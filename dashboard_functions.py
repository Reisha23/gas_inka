import pandas as pd
import plotly.express as px
from query import *
import streamlit as st

# loading data
def load_data():
    all_stock_data = view_all_stock() #menambahkan fungsi menampilkan seluruh data stock
    gas_allocation_data = get_gas_allocation()
    gas_demand_data = get_gas_demand()
    gas_allocation_demand_data = get_gas_allocation_demand()
    gas_supply_demand_data = get_gas_supply_demand()
    mutasi_by_date = get_mutasi_by_date()
    mutasi_history = view_mutasi_history()  # Menambahkan fungsi untuk memuat data history mutasi
    return all_stock_data,gas_allocation_data, gas_demand_data, gas_allocation_demand_data, gas_supply_demand_data, mutasi_by_date, mutasi_history

#filtered function from sidebar
def display_filtered_data(filter_choice, filter_options):
    filtered_data = filter_options[filter_choice]

    if filter_choice == "Gas Allocation":
        st.dataframe(pd.DataFrame(filtered_data, columns=['ID operasi', 'ID produk', 'ID gas', 'estStart', 'estFinish']))
        
    elif filter_choice == "Gas Demand":
        df_gas_demand = pd.DataFrame(filtered_data, columns=['Jenis tabung', 'Quantity needed', 'Quantity stock', 'Order quantity'])
        st.dataframe(df_gas_demand)
        fig = px.line(df_gas_demand, x='Jenis tabung', y='Quantity needed', title='Total Gas Demand by Cylinder Type')
        st.plotly_chart(fig, use_container_width=True)
        
    elif filter_choice == "Gas Allocation Demand":
        st.dataframe(pd.DataFrame(filtered_data, columns=['lokasi', 'estStart', 'quantity needed', 'ID gas']))
        
    elif filter_choice == "Gas Supply Demand":
        st.dataframe(pd.DataFrame(filtered_data, columns=['lokasi', 'quantity needed', 'ID stock tabung', 'ID gas']))
        
    elif filter_choice == "Mutasi by Date":
        if filtered_data:
            df_mutasi = pd.DataFrame(filtered_data, columns=['Tanggal Mutasi', 'Jumlah Mutasi'])
            fig = px.bar(df_mutasi, x='Tanggal Mutasi', y='Jumlah Mutasi', title='Mutasi by Date')
            st.plotly_chart(fig, use_container_width=True)
        else:
            st.warning("No data available for 'Mutasi by Date'")
            
    elif filter_choice == "Mutasi History":  # Menambahkan pilihan untuk menampilkan history mutasi
        st.dataframe(pd.DataFrame(filtered_data, columns=['Mutasi ID', 'Lokasi ID', 'Operasi ID', 'BPM ID', 'BPRM ID','Tanggal']))
        
#fungsi CRUD
# Create data
def create_data(table_name, data):
    conn = connect_to_database()
    if conn:
        cursor = conn.cursor()
        columns = ', '.join(data.keys())
        placeholders = ', '.join(['%s'] * len(data))
        query = f"INSERT INTO {table_name} ({columns}) VALUES ({placeholders})"
        try:
            cursor.execute(query, list(data.values()))
            conn.commit()
            st.success("Data inserted successfully")
        except mysql.connector.Error as e:
            conn.rollback()
            st.error(f"Error inserting data: {e}")
        finally:
            cursor.close()
            conn.close()

# Read data
def read_data(table_name):
    query = f"SELECT * FROM {table_name}"
    return execute_query(query)

# Update data
def update_data(table_name, data, condition):
    conn = connect_to_database()
    if conn:
        cursor = conn.cursor()
        set_clause = ', '.join([f"{key} = %s" for key in data.keys()])
        condition_clause = ' AND '.join([f"{key} = %s" for key in condition.keys()])
        values = list(data.values()) + list(condition.values())
        query = f"UPDATE {table_name} SET {set_clause} WHERE {condition_clause}"
        try:
            cursor.execute(query, values)
            conn.commit()
            st.success("Data updated successfully")
        except mysql.connector.Error as e:
            conn.rollback()
            st.error(f"Error updating data: {e}")
        finally:
            cursor.close()
            conn.close()

# Delete data
def delete_data(table_name, condition):
    conn = connect_to_database()
    if conn:
        cursor = conn.cursor()
        condition_clause = ' AND '.join([f"{key} = %s" for key in condition.keys()])
        query = f"DELETE FROM {table_name} WHERE {condition_clause}"
        try:
            cursor.execute(query, list(condition.values()))
            conn.commit()
            st.success("Data deleted successfully")
        except mysql.connector.Error as e:
            conn.rollback()
            st.error(f"Error deleting data: {e}")
        finally:
            cursor.close()
            conn.close()
