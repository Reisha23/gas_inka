import pandas as pd
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
            dataFix.append((item[4].strftime('%Y-%m-%d %H:%M:%S'),item[5],item[7],item[11],item[13]))
        df = pd.DataFrame(dataFix, columns=("Tanggal Masuk","Jumlah Masuk","Nama Gas","Total Stock","Supplier"))
        st.table(df)
        
    elif filter_transaction == "Gas keluar":
        data = view_all_keluar()
        dataFix = []
        for item in data:
            dataFix.append((item[4].strftime('%Y-%m-%d %H:%M:%S'),item[5],item[7],item[11],item[13]))
        df = pd.DataFrame(dataFix, columns=("Tanggal keluar","Jumlah keluar","Nama Gas","Stock Tersisa","Supplier"))
        st.table(df)

#filtered function sidebar supplier
def display_filtered_supplier(filter_choice):
    angka = 1
    
    if filter_choice == "SGI":
        angka = 1
        data = view_all_supplier(angka)
        dataFix = []
        for item in data:
            dataFix.append((item[1],item[5]))
        df = pd.DataFrame(dataFix, columns=("Nama Gas","Total Stock"))
        # Mengubah kolom pertama menjadi angka yang dimulai dari 1
        df.iloc[:, 0] = range(1, len(df) + 1)
        st.table(df)
        
    elif filter_choice == "SIG":
        angka = 2
        data = view_all_supplier(angka)
        dataFix = []
        for item in data:
            dataFix.append((item[1],item[5]))
        df = pd.DataFrame(dataFix, columns=("Nama Gas","Total Stock"))
        st.table(df)
    
    elif filter_choice == "LANGGENG":
        angka = 3
        data = view_all_supplier(angka)
        dataFix = []
        for item in data:
            dataFix.append((item[1],item[5]))
        df = pd.DataFrame(dataFix, columns=("Nama Gas","Total Stock"))
        st.table(df)
        
    elif filter_choice == "TIRA":
        angka = 4
        data = view_all_supplier(angka)
        dataFix = []
        for item in data:
            dataFix.append((item[1],item[5]))
        df = pd.DataFrame(dataFix, columns=("Nama Gas","Total Stock"))
        st.table(df)
        
    elif filter_choice == "SAMATOR":
        angka = 5
        data = view_all_supplier(angka)
        dataFix = []
        for item in data:
            dataFix.append((item[1],item[5]))
        df = pd.DataFrame(dataFix, columns=("Nama Gas","Total Stock"))
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
    print(is_masuk)
    data = get_all_user()
    dataTabung = get_all_tabung()
    dataSupplier = get_all_supplier()
    dataUserAll = []
    dataSupplierAll = []
    dataTabungAll = []
    for item in data:
       dataUserAll.append(
           {
               "id" : item[0],
               "nama" : item[1]
           }
       )
    for item in dataTabung:
       dataTabungAll.append(
           {
               "id" : item[0],
               "nama" : item[1]
           }
       )
    for item in dataSupplier:
       dataSupplierAll.append(
           {
               "id" : item[0],
               "nama" : item[1]
           }
       )
    
    tabung_options = get_select_options('tabung', 'id_tabung', 'nama_tabung')
    supplier_options = get_select_options('supplier', 'id_supplier', 'nama_supplier')
    user_options = get_select_options('pengguna', 'id_user', 'nama_user')
    
    user_names = [user['nama'] for user in dataUserAll]
    tabung_names = [tabung['nama'] for tabung in dataTabungAll]
    supplier_names = [supplier['nama'] for supplier in dataSupplierAll]
    
    st.subheader("Input Data Gas")
    
    if 'selected_tabung' not in st.session_state:
        st.session_state.selected_tabung = None
    if 'selected_supplier' not in st.session_state:
        st.session_state.selected_supplier = None
    if 'selected_user' not in st.session_state:
        st.session_state.selected_user = None
    if 'jumlah' not in st.session_state:
        st.session_state.jumlah = 1

    st.session_state.selected_tabung = st.selectbox("Select Tabung", tabung_names)
    st.session_state.selected_supplier = st.selectbox("Select Supplier", supplier_names)
    st.session_state.selected_user = st.selectbox("Select User", user_names)
    st.session_state.jumlah = st.number_input("Jumlah", min_value=1, step=1, value=st.session_state.jumlah)
   

    if st.button("Submit"):
        tabung_id = 0
        supplier_id = 0
        user_id = 0
        for item in dataUserAll:
            if item['nama'] == st.session_state.selected_user:
               user_id = item['id']
               break
        for item in dataTabungAll:
            if item['nama'] == st.session_state.selected_tabung:
               tabung_id  = item['id']
               break
        for item in dataSupplierAll:
            if item['nama'] == st.session_state.selected_supplier:
               supplier_id = item['id']
               break
        
        
        jumlah = st.session_state.jumlah
        query = "INSERT INTO gas_masuk (id_tabung, id_user, id_supplier, jumlah_masuk) VALUES (%s, %s, %s, %s)"
        
        if is_masuk:
            query = "INSERT INTO gas_masuk (id_tabung, id_user, id_supplier, jumlah_masuk) VALUES (%s, %s, %s, %s)"
        else:
            query = "INSERT INTO gas_keluar (id_tabung, id_user, id_supplier, jumlah_keluar) VALUES (%s, %s, %s, %s)"
        
        params = tabung_id,user_id,supplier_id,jumlah
        
        try:
           if executeInserQuery(query,params):
             st.success("Data successfully submitted!")
           else:
              st.error("Internal Error")
        except:
          st.error("Internal Error")
        

#menambahkan notifikasi peringatan ketika supply mulai menipis

# format codingan agar lebih rapi ketika semua sudah work
# ! deploying web app.py