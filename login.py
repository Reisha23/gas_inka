import streamlit as st
import pandas as pd
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
            if 'filter_masuk' not in st.session_state:
                st.session_state.filter_masuk = True
                st.session_state.filter_keluar = False
                
            if st.button("input gas masuk"):
                st.session_state.filter_masuk = True
                st.session_state.filter_keluar = False

            if st.button("input gas keluar"):
                print('halo')
                st.session_state.filter_keluar = True
                st.session_state.filter_masuk = False
            
            isMasuk = st.session_state.filter_masuk
                                   
        #memanggil filter berdasarkan pilihan checkbox
        if filter_choice:
            data = display_filtered_supplier(filter_choice)
        if filter_transaction:
            data = display_filtered_data(filter_transaction)
        
        display_input_data(isMasuk)
                    

        # Button view all stock
        st.subheader("tampilkan seluruh stock :")
        if st.button("View All Stock"):
            all_stock_data = get_all_stock_tabung()
            dataFinal = []
            stockTemp = [0, 0, 0, 0]
            id_temp = 0
            nama_temp = ''
            stock_temp = 0
            index = 0
            stock_mapping = {'LANGGENG': 0, 'SAMATOR': 1, 'SIG': 2, 'TIRA': 3}
            for item in all_stock_data:
                if id_temp == 0:
                   id_temp = item[0]
                   nama_temp = item[1]
                
                if id_temp != item[0]: 
                    dataFinal.append((nama_temp,*stockTemp,sum(stockTemp)))
                    stockTemp = [0,0,0,0]
                    id_temp = item[0]
                    nama_temp = item[1]
                elif index+1 == len(all_stock_data):
                     if id_temp != item[0]:
                           dataFinal.append((nama_temp,*stockTemp,sum(stockTemp)))
                           stockTemp = [0,0,0,0]
                           id_temp = item[0]
                           nama_temp = item[1]
                           stockTemp[stock_mapping[item[2]]] = item[3]
                           dataFinal.append((nama_temp,*stockTemp,sum(stockTemp)))
                           break
                     else:
                         stockTemp[stock_mapping[item[2]]] = item[3]
                         dataFinal.append((nama_temp,*stockTemp,sum(stockTemp)))
                         stockTemp = [0,0,0,0]
                         break
                         
                stockTemp[stock_mapping[item[2]]] = item[3]
                  
                index+=1
            
            print(dataFinal)
                             
            if all_stock_data:
                st.write("Data Tersedia :")
                data = view_all_stock()
                df = pd.DataFrame(dataFinal, columns=( "Nama", "Langgeng", "Samator", "SIG", "TIRA", "Total Stock"))
                st.table(df)

        #button view history
        st.subheader("tampilkan history :")
        if st.button("history"):
            all_history_data = view_all_history()
            if all_history_data:
                st.write("History keluar masuk gas :")
                data = view_all_history()                    
                dataFix = []
                for item in data:
                        dataFix.append((item[4],item[5],item[6],item[12],item[14],item[8]))
                df = pd.DataFrame(dataFix, columns=("Tanggal", "Jenis Aktivitas", "Jumlah", "Gas", "Supplier", "User Input"))
                print(dataFix)
                st.table(df)
                