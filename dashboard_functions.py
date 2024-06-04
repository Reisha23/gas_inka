import pandas as pd
import plotly.express as px
import streamlit as st
from query import *
from datetime import datetime

# loading data
def load_data():
    all_stock_data = view_all_stock() #menambahkan fungsi menampilkan seluruh data stock
    return all_stock_data

#filtered function from sidebar
def display_filtered_data(filter_transaction):

    if filter_transaction == "Gas masuk":
        data = view_all_masuk()
        dataFix = []
        for item in data:
            dataFix.append((item[4].strftime('%Y-%m-%d %H:%M:%S'),item[5],item[7],item[10],item[11],item[13]))
        #print(dataFix[0])
        df = pd.DataFrame(dataFix, columns=("Tanggal Masuk","Jumlah Masuk","Tabung","Kode Supplier","Total Stock","Supplier"))
        st.table(df)
        
    elif filter_transaction == "Gas keluar":
        data = view_all_keluar()
        dataFix = []
        for item in data:
            dataFix.append((item[4].strftime('%Y-%m-%d %H:%M:%S'),item[5],item[7],item[10],item[11],item[13]))
        #print(dataFix[0])
        df = pd.DataFrame(dataFix, columns=("Tanggal keluar","Jumlah keluar","Tabung","Kode Supplier","Total Stock","Supplier"))
        st.table(df)


#filtered function sidebar supplier
def display_filtered_supplier(filter_choice):
    angka = 1
    
    if filter_choice == "SGI":
        angka = 1
        data = view_all_supplier(angka)
        df = pd.DataFrame(data, columns=("ID Tabung","Nama Tabung","Jenis Tabung","Id Supplier","Kode Supplier","Total Stock"))
        # Mengubah kolom pertama menjadi angka yang dimulai dari 1
        df.iloc[:, 0] = range(1, len(df) + 1)
        st.table(df)
        
    elif filter_choice == "SIG":
        angka = 2
        data = view_all_supplier(angka)
        df = pd.DataFrame(data, columns=("ID Tabung","Nama Tabung","Jenis Tabung","Id Supplier","Kode Supplier","Total Stock"))
        # Mengubah kolom pertama menjadi angka yang dimulai dari 1
        df.iloc[:, 0] = range(1, len(df) + 1)
        st.table(df)
    
    elif filter_choice == "LANGGENG":
        angka = 3
        data = view_all_supplier(angka)
        df = pd.DataFrame(data, columns=("ID Tabung","Nama Tabung","Jenis Tabung","Id Supplier","Kode Supplier","Total Stock"))
        # Mengubah kolom pertama menjadi angka yang dimulai dari 1
        df.iloc[:, 0] = range(1, len(df) + 1)
        st.table(df)
        
    elif filter_choice == "TIRA":
        angka = 4
        data = view_all_supplier(angka)
        df = pd.DataFrame(data, columns=("ID Tabung","Nama Tabung","Jenis Tabung","Id Supplier","Kode Supplier","Total Stock"))
        # Mengubah kolom pertama menjadi angka yang dimulai dari 1
        df.iloc[:, 0] = range(1, len(df) + 1)
        st.table(df)
        
    elif filter_choice == "SAMATOR":
        angka = 5
        data = view_all_supplier(angka)
        df = pd.DataFrame(data, columns=("ID Tabung","Nama Tabung","Jenis Tabung","Id Supplier","Kode Supplier","Total Stock"))
        # Mengubah kolom pertama menjadi angka yang dimulai dari 1
        df.iloc[:, 0] = range(1, len(df) + 1)
        st.table(df)
    
# Fungsi filter CRU
# Fungsi untuk mendapatkan pilihan dari tabel
def get_select_options(table, id_col, name_col):
    query = f"SELECT {id_col}, {name_col} FROM {table}"
    result = execute_query(query)
    if result:
        options = {name: id for id, name in result}
        return options
    else:
        return {}
    
# Fungsi untuk menampilkan input form dan menginput data ke database
def display_input_data(is_masuk):
    tabung_options = get_select_options('tabung', 'id_tabung', 'nama_tabung')
    supplier_options = get_select_options('supplier', 'id_supplier', 'nama_supplier')
    user_options = get_select_options('pengguna', 'id_user', 'nama_user')
    
    st.subheader("Input Data Gas")
    selected_tabung = st.selectbox("Select Tabung", list(tabung_options.keys()))
    selected_supplier = st.selectbox("Select Supplier", list(supplier_options.keys()))
    selected_user = st.selectbox("Select User", list(user_options.keys()))
    jumlah = st.number_input("Jumlah", min_value=1, step=1)

    if st.button("Submit"):
        tabung_id = tabung_options[selected_tabung]
        supplier_id = supplier_options[selected_supplier]
        user_id = user_options[selected_user]
        
        if is_masuk:
            query = '''
                INSERT INTO gas_masuk (id_tabung, id_supplier, id_user, jumlah_masuk)
                VALUES (%s, %s, %s, %s)
            '''
        else:
            query = '''
                INSERT INTO gas_keluar (id_tabung, id_supplier, id_user, jumlah_keluar)
                VALUES (%s, %s, %s, %s)
            '''
        
        params = (tabung_id, supplier_id, user_id, jumlah)
        execute_query(query, params)
        st.success("Data successfully submitted!")
# !noted masih belum dapat menginput data setelah submit, bug ketika memilih opsi, web akan terestart

# fungsi menampilkan table dengan nilai dari supplier kemudian jenis tabung dan output yang dihasilkan adalah
# jumlah total stock dari setiap supplier serta menambahkan notifikasi peringatan ketika supply mulai menipis
# format codingan agar lebih rapi ketika semua sudah work
# ! deploying web app.py