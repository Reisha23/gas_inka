import streamlit as st
import pandas as pd
import plotly.express as px
from dashboard_functions import *

# Set page configuration
st.set_page_config(
    page_title="INKA Distribution Gas Dashboard",
    page_icon="🏭"
)

# Styling CSS
sidebar_style = """
    <style>
        .sidebar .sidebar-content {
            display: flex;
            flex-direction: column;
            align-items: center;
        }
    </style>
"""
st.markdown(sidebar_style, unsafe_allow_html=True)

# Function untuk fetching users dari database
def fetch_users():
    users = read_data('user')
    return [user[2] for user in users]

# Inisiasi select user
if 'selected_user' not in st.session_state:
    st.title("Select User")
    users = fetch_users()
    selected_user = st.selectbox("Please select your user:", users)
    if st.button("Proceed"):
        st.session_state.selected_user = selected_user
        st.experimental_rerun()

# Jika user dipilih, menampilkan dashboard
if 'selected_user' in st.session_state:
    st.title(f"Welcome {st.session_state.selected_user} to INKA Gas Dashboard")
    st.write("Menampilkan data gas yang diperlukan melalui filter & fitur yang tersedia.")

    # Sidebar
    with st.sidebar:
        st.image("pictures/logo.png", width=128)
        
        st.subheader("filter options :")
        filter_choice = st.selectbox(
            "Filter Data", ["Gas Allocation", "Gas Demand", "Gas Allocation Demand", "Gas Supply Demand", "Mutasi by Date", "Mutasi History"], index=5)

        st.subheader("edit data :")
        operation_choice = st.selectbox(
            "Choose Operation", ["Create", "Read", "Update", "Delete"])

    # Button view all stock
    if st.button("View All Stock"):
        all_stock_data = view_all_stock()
        if all_stock_data:
            st.write("Data Tersedia :")
            st.table(all_stock_data)
            
            # Bar chart
            df = pd.DataFrame(all_stock_data, columns=["ID Tabung", "Jenis Tabung", "Keterangan"])
            fig = px.bar(df, x="Jenis Tabung", y="Keterangan", color="ID Tabung", title="Stok Gas Berdasarkan Jenis")
            
            # Menambahkan color threshold feature
            threshold = 6
            df['Color'] = 'green'  # Default color
            
            df.loc[df['Keterangan'] < threshold, 'Color'] = 'red'  # Jika indikator di bawah threshold
            
            # Warning message jika stock di bawah 80
            low_stock_warning = df[df['Keterangan'] < threshold]
            if not low_stock_warning.empty:
                st.markdown(
                    '<style>div[data-testid="stToast"] div div { background-color: red; }</style>',
                    unsafe_allow_html=True
                )
                st.warning("Peringatan: Stok di bawah ambang batas kebutuhan.")
                st.table(low_stock_warning[['ID Tabung', 'Jenis Tabung', 'Keterangan']])
            
            fig.update_traces(marker=dict(color=df['Color']))
            st.plotly_chart(fig, use_container_width=True)
        else:
            st.warning("No data available.")
            
    # Load data berdasarkan filter choice
    all_stock_data, gas_allocation_data, gas_demand_data, gas_allocation_demand_data, gas_supply_demand_data, mutasi_by_date, mutasi_history = load_data()
    
    # Dictionary untuk opsi filter
    filter_options = {
        "Gas Allocation": gas_allocation_data,
        "Gas Demand": gas_demand_data,
        "Gas Allocation Demand": gas_allocation_demand_data,
        "Gas Supply Demand": gas_supply_demand_data,
        "Mutasi by Date": mutasi_by_date,
        "Mutasi History": mutasi_history
    }
    
    # Tampilkan data berdasarkan filter choice
    display_filtered_data(filter_choice, filter_options)
    
    # Implementasi operasi CRUD
    st.subheader(f"{operation_choice} Data")
    
    if operation_choice == "Create":
        table_name = st.text_input("Table Name:")
        columns = st.text_area("Columns (comma-separated):")
        values = st.text_area("Values (comma-separated):")
        
        if st.button("Create"):
            data = dict(zip(columns.split(','), values.split(',')))
            create_data(table_name, data)
    
    elif operation_choice == "Read":
        table_name = st.text_input("Table Name:")
        
        if st.button("Read"):
            data = read_data(table_name)
            if data:
                st.table(data)
            else:
                st.warning("No data available.")
    
    elif operation_choice == "Update":
        table_name = st.text_input("Table Name:")
        columns = st.text_area("Columns to update (comma-separated):")
        values = st.text_area("New values (comma-separated):")
        condition_columns = st.text_area("Condition columns (comma-separated):")
        condition_values = st.text_area("Condition values (comma-separated):")
        
        if st.button("Update"):
            data = dict(zip(columns.split(','), values.split(',')))
            condition = dict(zip(condition_columns.split(','), condition_values.split(',')))
            update_data(table_name, data, condition)
    
    elif operation_choice == "Delete":
        table_name = st.text_input("Table Name:")
        condition_columns = st.text_area("Condition columns (comma-separated):")
        condition_values = st.text_area("Condition values (comma-separated):")
        
        if st.button("Delete"):
            condition = dict(zip(condition_columns.split(','), condition_values.split(',')))
            delete_data(table_name, condition)