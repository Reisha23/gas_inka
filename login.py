import streamlit as st
import pandas as pd
import plotly.express as px
import hashlib
import mysql.connector
from dashboard_functions import *
# Fungsi untuk membuat koneksi ke database MySQL
def connect_to_database():
    try:
        conn = mysql.connector.connect(
            host="127.0.0.1",
            user="root",
            password="",
            database="gas_rev"
        )
        if conn.is_connected():
            return conn
    except mysql.connector.Error as e:
        st.error(f"Error connecting to MySQL database: {e}")
        return None

# Fungsi untuk melakukan query dan fetch data
def execute_query(query, params=None):
    conn = connect_to_database()
    if conn:
        cursor = conn.cursor()
        cursor.execute(query, params)
        result = cursor.fetchall()
        cursor.close()
        conn.close()
        return result
    else:
        return None

# Fungsi untuk login user
def login_user(email_user, password_user):
    query = '''
        SELECT nama_user FROM pengguna 
        WHERE email_user = %s AND password_user = MD5(%s)
    '''
    result = execute_query(query, (email_user, password_user))
    if result:
        return result[0][0]
    else:
        return None

# Halaman login
def login_page():
    if 'logged_in_user' not in st.session_state:
        st.title("User Login")
        email = st.text_input("Email")
        password = st.text_input("Password", type="password")
        if st.button("Login"):
            user = login_user(email, password)
            if user:
                st.session_state.logged_in_user = user
                st.experimental_rerun()
            else:
                st.error("Invalid email or password")

        if st.button("Go to Register"):
            st.session_state.page = 'register'
            st.experimental_rerun()
    else:
        st.title(f"Welcome {st.session_state.logged_in_user} to INKA Gas Dashboard")
        st.write("Menampilkan data gas yang diperlukan melalui filter & fitur yang tersedia.")

        # Sidebar
        with st.sidebar:
            st.image("pictures/logo.png", width=128)
            
            st.subheader("filter options :")
            filter_choice = st.selectbox(
                "Filter gas", ["Gas masuk", "Gas keluar"])

            st.subheader("edit data :")
            operation_choice = st.selectbox(
                "pilih operasi", ["Create", "Read", "Update", "Delete"])

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
                threshold = 80
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
        gas_masuk, gas_keluar = load_data()
        
        # Dictionary untuk opsi filter
        filter_options = {
            "Gas Masuk": gas_masuk,
            "Gas Keluar": gas_keluar
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
