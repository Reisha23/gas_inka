import mysql.connector
import streamlit as st

#koneksi database mysql
# Fungsi untuk membuat koneksi ke database MySQL
def connect_to_database():
    try:
        conn = mysql.connector.connect(
            host="127.0.0.1",
            #port="3306",
            user="root",
            password="",
            database="gas_rev"
        )
        if conn.is_connected():
            return conn
    except mysql.connector.Error as e:
        st.error(f"Error connecting to MySQL database: {e}")
        return None

# Fungsi untuk mengeksekusi query dan mengambil hasilnya
def execute_query(query):
    conn = connect_to_database()
    if conn:
        cursor = conn.cursor()
        cursor.execute(query)
        result = cursor.fetchall()
        cursor.close()
        conn.close()
        return result
    else:
        return None

#fetch QUERY

#tampilkan seluruh stok dan jenis gas yang ada di gudang
def view_all_stock():
    query = '''
    '''
    return execute_query(query)

def gas_masuk():
    query = '''
    SELECT 
    '''
    return execute_query(query)


# Query untuk melihat gas keluar
def gas_keluar():
    query = '''
    '''
    return execute_query(query)


