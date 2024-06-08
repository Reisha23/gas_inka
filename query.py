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

def executeInserQuery(query,param):
    conn = connect_to_database()
    if conn:
        cursor = conn.cursor()
        args = param
        cursor.execute(query,args)
        conn.commit()
        cursor.close()
        conn.close()
        return True
    else:
        return False
    

#fetching query
#tampilkan seluruh stok dan jenis gas yang ada di gudang
def view_all_stock():
    query = '''
    SELECT * FROM `tabung` 
    '''
    return execute_query(query)

#tampilkan seluruh gas yang masuk
def view_all_supplier(id_supplier):
    query = f"SELECT * FROM `tabung` WHERE id_supplier = {id_supplier}"
    return execute_query(query)

#tampilkan seluruh gas yang masuk
def view_all_masuk():
    query = '''
    SELECT
    *
    FROM
        `gas_masuk`
    INNER JOIN tabung ON tabung.id_jenis_tabung = gas_masuk.id_tabung AND tabung.id_supplier = gas_masuk.id_supplier
    INNER JOIN supplier ON tabung.id_supplier = supplier.id_supplier
    '''
    return execute_query(query)

#tampilkan seluruh gas yang keluar
def view_all_keluar():
    query = '''
    SELECT
    *
    FROM
        `gas_keluar`
    INNER JOIN tabung ON tabung.id_jenis_tabung = gas_keluar.id_tabung AND tabung.id_supplier = gas_keluar.id_supplier
    INNER JOIN supplier ON tabung.id_supplier = supplier.id_supplier
    '''
    return execute_query(query)

def view_all_history():
    query = '''
    SELECT
    *
    FROM
        `gas_history`
    INNER JOIN pengguna ON gas_history.id_user = pengguna.id_user
    INNER JOIN jenis_tabung ON gas_history.id_tabung = jenis_tabung.id_jenis_tabung
    INNER JOIN supplier ON gas_history.id_supplier = supplier.id_supplier
    '''
    return execute_query(query)

def get_all_user():
    query = f"SELECT * FROM `pengguna`"
    return execute_query(query)

def get_all_tabung() :
    query = f"SELECT * FROM `jenis_tabung`"
    return execute_query(query)

def get_all_supplier() :
    query = f"SELECT * FROM `supplier`"
    return execute_query(query)

def get_all_stock_tabung():
    query = f"SELECT tabung.id_jenis_tabung, jenis_tabung.jenis_tabung, supplier.nama_supplier, tabung.total_stock FROM tabung INNER JOIN jenis_tabung ON jenis_tabung.id_jenis_tabung = tabung.id_jenis_tabung INNER JOIN supplier ON supplier.id_supplier = tabung.id_supplier GROUP BY id_jenis_tabung, nama_tabung;"
    return execute_query(query)
    
