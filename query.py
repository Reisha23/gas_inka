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
            database="gudang_gas_db"
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

#query menampilkan seluruh table
def show_all_table():
    query = '''
        SHOW TABLES;
    '''
    return execute_query(query)

#tampilkan seluruh stok dan jenis gas yang ada di gudang
def view_all_stock():
    query = '''
        SELECT 
        jenis_tabung.jenis_tabung AS 'jenis gas',
        supplier.nama_supplier AS 'supplier', 
        COUNT(tabung.id_tabung) AS 'jumlah stok'
    FROM 
        tabung
    JOIN 
        jenis_tabung ON tabung.id_jenis_tabung = jenis_tabung.id_jenis_tabung
    JOIN 
        supplier ON tabung.id_supplier = supplier.id_supplier
    GROUP BY 
        jenis_tabung.jenis_tabung, supplier.nama_supplier;
    '''
    return execute_query(query)

# Query untuk menampilkan history mutasi
def view_mutasi_history():
    query = '''
        SELECT 
            id_mutasi AS mutasi_ID,
            id_lokasi AS lokasi_ID,
            id_operasi AS operasi_ID,
            bpm_id_bpm AS BPM_ID,
            bprm_id_bprm AS BPRM_ID,
            tanggal_mutasi AS tanggal
        FROM 
            history_mutasi
    '''
    return execute_query(query)


# Query untuk menentukan operasi yang akan dialokasikan kebutuhan gas
def get_gas_allocation():
    query = '''
        SELECT 
            operasi.id_operasi AS 'operator ID',
            operasi.id_product AS 'product ID',
            detail_bpm.id_jenis_gas AS 'gas ID',
            operasi.estStartTime AS 'estStart',
            operasi.estFinishTime AS 'estFinish'
        FROM
            operasi
        JOIN
            detail_bpm ON operasi.id_product = detail_bpm.id_bpm
    '''
    return execute_query(query)

# Query untuk menentukan kebutuhan total gas
def get_gas_demand():
    query = '''
        SELECT 
            jenis_tabung.jenis_tabung,
            COALESCE(SUM(detail_bpm.kuantitas), 0) AS quantity_needed,
            COALESCE(SUM(detail_bprm.kuantitas), 0) AS quantity_stock,
            COALESCE(SUM(detail_bpm.kuantitas), 0) - COALESCE(SUM(detail_bprm.kuantitas), 0) AS order_quantity
        FROM 
            detail_bpm
        LEFT JOIN jenis_tabung ON detail_bpm.id_jenis_gas = jenis_tabung.id_jenis_tabung
        LEFT JOIN detail_bprm ON detail_bpm.id_jenis_gas = detail_bprm.id_jenis_tabung
        GROUP BY jenis_tabung.jenis_tabung;
    '''
    return execute_query(query)

# Query untuk menentukan alokasi kebutuhan gas
def get_gas_allocation_demand():
    query = '''
        SELECT hm.id_lokasi AS lokasi,
               o.estStartTime,
               db.kuantitas AS quantity_kebutuhan,
               db.id_jenis_gas AS gas_id
        FROM history_mutasi hm
        JOIN operasi o ON hm.id_operasi = o.id_operasi
        JOIN detail_bpm db ON hm.bpm_id_bpm = db.id_bpm
    '''
    return execute_query(query)

# Query untuk menentukan pengadaan kebutuhan gas        
def get_gas_supply_demand():
    query = '''
        SELECT hm.id_lokasi AS lokasi,
               SUM(db.kuantitas) AS quantity_kebutuhan,
               t.id_tabung AS stock_tabung_id,
               db.id_jenis_gas AS gas_id
        FROM history_mutasi hm
        JOIN detail_bpm db ON hm.bpm_id_bpm = db.id_bpm
        JOIN tabung t ON db.id_jenis_gas = t.id_jenis_tabung
        GROUP BY hm.id_lokasi, db.id_jenis_gas, t.id_tabung
    '''
    return execute_query(query)

#Query menampilkan grafik batang dari jumlah mutasi berdasarkan tanggal
def get_mutasi_by_date():
    query = '''
        SELECT tanggal_mutasi, COUNT(*) AS jumlah_mutasi
        FROM history_mutasi
        GROUP BY tanggal_mutasi
    '''
    return execute_query(query)


