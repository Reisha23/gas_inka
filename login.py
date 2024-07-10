import streamlit as st
import pandas as pd
import plotly.express as px
import mysql.connector
import hashlib
from dashboard_functions import *
from transaction_page import show_transaction_page

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
def login_user(nama_user, password_user):
    query = '''
        SELECT * FROM pengguna 
        WHERE nama_user = %s AND password_user = MD5(%s)
    '''
    result = execute_query(query, (nama_user, password_user))
    if result:
        return result[0][1]  # Mengembalikan nama pengguna
    else:
        return None

# Halaman login
def login_page():
    st.title("User Login")
    username = st.text_input("Nama")
    password = st.text_input("Password", type="password")
    if st.button("Login"):
        user = login_user(username, password)
        if user:
            st.session_state.logged_in_user = user
            st.session_state.page = 'dashboard'
            st.experimental_rerun()
        else:
            st.error("Invalid username or password")

    if st.button("Go to Register"):
        st.session_state.page = 'register'
        st.experimental_rerun()

# Halaman dashboard
def dashboard_page():
    st.title(f"Welcome {st.session_state.logged_in_user} to INKA Gas Dashboard")

    # Sidebar
    with st.sidebar:
        st.image("pictures/logo.png", width=128)
        
        #select box untuk default dan menu utama dashboard
        st.subheader("Menu Utama :")
        page = st.radio("Pilih Halaman:", ["Dashboard", "Transaction"])

    if page == "Dashboard":
        st.subheader("Total stock gas:")
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
                total_stock = sum(stockTemp)
                dataFinal.append((nama_temp, *stockTemp, total_stock))
                stockTemp = [0, 0, 0, 0]
                id_temp = item[0]
                nama_temp = item[1]
                if total_stock < 80:
                    st.warning(f"Stock {nama_temp} dibawah ambang batas! Total stock: {total_stock}")
            elif index + 1 == len(all_stock_data):
                if id_temp != item[0]:
                    total_stock = sum(stockTemp)
                    dataFinal.append((nama_temp, *stockTemp, total_stock))
                    stockTemp = [0, 0, 0, 0]
                    id_temp = item[0]
                    nama_temp = item[1]
                    stockTemp[stock_mapping[item[2]]] = item[3]
                    total_stock = sum(stockTemp)
                    dataFinal.append((nama_temp, *stockTemp, total_stock))
                    if total_stock < 80:
                        st.warning(f"Stock {nama_temp} dibawah ambang batas! Total stock: {total_stock}")
                    break
                else:
                    stockTemp[stock_mapping[item[2]]] = item[3]
                    total_stock = sum(stockTemp)
                    dataFinal.append((nama_temp, *stockTemp, total_stock))
                    if total_stock < 80:
                        st.warning(f"Stock {nama_temp} dibawah ambang batas! Total stock: {total_stock}")
                    stockTemp = [0, 0, 0, 0]
                    break
                     
            stockTemp[stock_mapping[item[2]]] = item[3]
            index += 1
        
        print(dataFinal)
                         
        if all_stock_data:
            df = pd.DataFrame(dataFinal, columns=("Nama", "Langgeng", "Samator", "SIG", "TIRA", "Total Stock"))
            st.table(df)
            
            # Tambahkan warna pada sel yang bernilai 0
            st.subheader("summary table total stok gas :")
            st.write("arahkan cursor pada table kemudian pilih icon unduh untuk eksport table ke file CSV! ")
            def highlight_zero(val):
                color = 'red' if val == 0 else 'white'
                return f'background-color: {color}'
            
            styled_df = df.style.applymap(highlight_zero, subset=pd.IndexSlice[:, ["Langgeng", "Samator", "SIG", "TIRA"]])
            st.dataframe(styled_df)
            
            # Tambahkan grafik batang
            df['Status'] = df['Total Stock'].apply(lambda x: 'Aman' if x >= 80 else 'Dibawah Ambang Batas')
            fig = px.bar(df, x='Nama', y='Total Stock', color='Status',
                         color_discrete_map={'Aman': 'green', 'Dibawah Ambang Batas': 'red'},
                         title="Total Stock Gas")
            st.plotly_chart(fig)

    elif page == "Transaction":
        show_transaction_page()

if __name__ == "__main__":
    main()
