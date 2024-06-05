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
        SELECT * FROM pengguna 
        WHERE email_user = %s AND password_user = MD5(%s)
    '''
    result = execute_query(query, (email_user, password_user))
    if result:
        return result[0][1]
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
            
            #select box filter transaksi gas masuk & keluar
            st.subheader("filter gas :")
            filter_transaction = st.selectbox(
                "Filter gas", ["Gas masuk", "Gas keluar"])
            
            st.subheader("all stock by supplier :")
            filter_choice = st.selectbox(
                "filter supplier", ["SIG", "LANGGENG", "TIRA", "SAMATOR"])
            
            #button filter CRU gas masuk & keluar
            st.subheader("tambahkan data :")
            if st.button("input gas masuk"):
                st.session_state.filter_masuk = True
                st.session_state.filter_keluar = False
                st.experimental_rerun()

            if st.button("input gas keluar"):
                st.session_state.filter_keluar = True
                st.session_state.filter_masuk = False
                st.experimental_rerun()
                
            st.subheader("tampilkan table :")
            if st.button("Tampilkan Stok"):
                display_stok_data()
        
        #memanggil filter berdasarkan pilihan checkbox
        if filter_choice:
            data = display_filtered_supplier(filter_choice)
        if filter_transaction:
            data = display_filtered_data(filter_transaction)
        if st.session_state.filter_masuk:
            display_input_data(True)
        if st.session_state.filter_keluar:
            display_input_data(False)                

        # Button view all stock
        if st.button("View All Stock"):
            all_stock_data = view_all_stock()
            if all_stock_data:
                st.write("Data Tersedia :")
                df = pd.DataFrame(all_stock_data, columns=("ID Tabung","Nama Tabung","Jenis Tabung","Id Supplier","Kode Supplier","Total Stock"))
                # Mengubah kolom pertama menjadi angka yang dimulai dari 1
                df.iloc[:, 0] = range(1, len(df) + 1)
                st.table(df)
                
        

