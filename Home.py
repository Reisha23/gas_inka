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

# Function to fetch users from the database
def fetch_users():
    # Replace this with your actual database fetching logic
    users = read_data('user')  # Assuming `read_data` function reads from 'user' table and returns a list of tuples
    return [user[2] for user in users]  # Extracting 'nama_pengguna'

# Initial User Selection
if 'selected_user' not in st.session_state:
    st.title("Select User")
    users = fetch_users()
    selected_user = st.selectbox("Please select your user:", users)
    if st.button("Proceed"):
        st.session_state.selected_user = selected_user
        st.experimental_rerun()

# If user is selected, show the dashboard
if 'selected_user' in st.session_state:
    st.title(f"Welcome {st.session_state.selected_user} to INKA Gas Dashboard")
    st.write("Menampilkan semua data gas yang diperlukan melalui filter & fitur yang tersedia.")

    # Sidebar
    with st.sidebar:
        st.image("pictures/logo.png", width=128)
        
        st.subheader("filter options :")
        filter_choice = st.selectbox(
            "Filter Data", ["Gas Allocation", "Gas Demand", "Gas Allocation Demand", "Gas Supply Demand", "Mutasi by Date", "Mutasi History"], index=5)

        st.subheader("edit data :")
        operation_choice = st.selectbox(
            "Choose Operation", ["Create", "Read", "Update", "Delete"])

    # Show tables list
    if st.button("Show All Tables"):
        all_tables = show_all_table()
        if all_tables:
            st.write("Tables available:")
            st.table({"Daftar": all_tables})
        else:
            st.write("No tables available.")

    # Button to view all stock
    if st.button("View All Stock"):
        all_stock_data = view_all_stock()
        if all_stock_data:
            st.write("Data Tersedia :")
            st.table(all_stock_data)
            
            # Creating bar chart
            df = pd.DataFrame(all_stock_data, columns=["ID Tabung", "Jenis Tabung", "Keterangan"])
            fig = px.bar(df, x="Jenis Tabung", y="Keterangan", color="ID Tabung", title="Stok Gas Berdasarkan Jenis")
            
            # Adding color threshold feature
            threshold = 80
            df['Color'] = 'green'  # default color
            
            df.loc[df['Keterangan'] < threshold, 'Color'] = 'red'
            
            # Warning message if stock is below 80
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
            
    # Load data based on filter choice
    if filter_choice in ["Gas Allocation", "Gas Allocation Demand"]:
        data = get_gas_allocation() if filter_choice == "Gas Allocation" else get_gas_allocation_demand()
    elif filter_choice == "Gas Demand":
        data = get_gas_demand()
    elif filter_choice == "Gas Supply Demand":
        data = get_gas_supply_demand()
    elif filter_choice == "Mutasi by Date":
        data = get_mutasi_by_date()
    elif filter_choice == "Mutasi History":
        data = view_mutasi_history()

    # Display filtered data
    display_filtered_data(filter_choice, {filter_choice: data})

    # CRUD operations
    if operation_choice == "Create":
        st.subheader("Create New Data")
        table_name = st.text_input("Table Name")
        data = {}  # Initialize dictionary for new data
        if st.button("Create Data"):
            create_data(table_name, data)
            
    elif operation_choice == "Read":
        st.subheader("Read Data")
        table_name = st.text_input("Table Name")
        if st.button("Read Data"):
            if table_name:
                data = read_data(table_name)
                if data:
                    st.write("Data Available:")
                    st.table(pd.DataFrame(data))  # Adjust column names accordingly
                else:
                    st.warning("No data available.")
            else:
                st.error("Please enter a table name.")
            
    elif operation_choice == "Update":
        st.subheader("Update Data")
        table_name = st.text_input("Table Name")
        data = {}  # Initialize dictionary for updated data
        condition = {}  # Initialize dictionary for condition
        if st.button("Update Data"):
            update_data(table_name, data, condition)
            
    elif operation_choice == "Delete":
        st.subheader("Delete Data")
        table_name = st.text_input("Table Name")
        condition = {}  # Initialize dictionary for condition
        if st.button("Delete Data"):
            delete_data(table_name, condition)
