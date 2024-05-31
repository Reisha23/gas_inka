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
    gm.id_tabung,
    jt.jenis_tabung AS nama_gas,
    CASE 
        WHEN gm.jumlah_masuk > 0 THEN 'Masuk'
        ELSE 'Tidak Masuk'
    END AS kondisi,
    gm.tanggal_masuk,
    gm.jumlah_masuk,
    (SELECT SUM(jumlah_masuk) FROM gas_masuk WHERE gas_masuk.id_tabung = gm.id_tabung) AS total_jumlah_masuk
    FROM 
        gas_masuk gm
    JOIN 
        tabung t ON gm.id_tabung = t.id_tabung
    JOIN 
        jenis_tabung jt ON t.id_jenis_tabung = jt.id_jenis_tabung;

    '''
    return execute_query(query)


# Query untuk melihat gas keluar
def gas_keluar():
    query = '''
    '''
    return execute_query(query)


