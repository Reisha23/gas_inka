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

    if filter_transaction== "Gas masuk":
        data = view_all_masuk()
        dataFix = []
        for item in data:
            dataFix.append((item[4].strftime('%Y-%m-%d %H:%M:%S'),item[5],item[7],item[10],item[11],item[13]))
        print(dataFix[0])
        df = pd.DataFrame(dataFix, columns=("Tanggal Masuk","Jumlah Masuk","Tabung","Kode Supplier","Total Stock","Supplier"))
        st.table(df)
        
    elif filter_transaction == "Gas keluar":
        data = view_all_keluar()
        dataFix = []
        for item in data:
            dataFix.append((item[4].strftime('%Y-%m-%d %H:%M:%S'),item[5],item[7],item[10],item[11],item[13]))
        print(dataFix[0])
        df = pd.DataFrame(dataFix, columns=("Tanggal keluar","Jumlah keluar","Tabung","Kode Supplier","Total Stock","Supplier"))
        st.table(df)


#filtered function sidebar supplier
def display_filtered_supplier(filter_choice):
    angka = 1
    
    if filter_choice == "SGI":
        angka = 1
        data = view_all_supplier(angka)
        df = pd.DataFrame(data, columns=("ID Tabung","Nomor Tabung","Jenis Tabung","Id Supplier","Kode Supplier","Total Stock"))
        # Mengubah kolom pertama menjadi angka yang dimulai dari 1
        df.iloc[:, 0] = range(1, len(df) + 1)
        st.table(df)
        
    elif filter_choice == "SIG":
        angka = 2
        data = view_all_supplier(angka)
        df = pd.DataFrame(data, columns=("ID Tabung","Nomor Tabung","Jenis Tabung","Id Supplier","Kode Supplier","Total Stock"))
        # Mengubah kolom pertama menjadi angka yang dimulai dari 1
        df.iloc[:, 0] = range(1, len(df) + 1)
        st.table(df)
    
    elif filter_choice == "LANGGENG":
        angka = 3
        data = view_all_supplier(angka)
        df = pd.DataFrame(data, columns=("ID Tabung","Nomor Tabung","Jenis Tabung","Id Supplier","Kode Supplier","Total Stock"))
        # Mengubah kolom pertama menjadi angka yang dimulai dari 1
        df.iloc[:, 0] = range(1, len(df) + 1)
        st.table(df)
        
    elif filter_choice == "TIRA":
        angka = 4
        data = view_all_supplier(angka)
        df = pd.DataFrame(data, columns=("ID Tabung","Nomor Tabung","Jenis Tabung","Id Supplier","Kode Supplier","Total Stock"))
        # Mengubah kolom pertama menjadi angka yang dimulai dari 1
        df.iloc[:, 0] = range(1, len(df) + 1)
        st.table(df)
        
    elif filter_choice == "SAMATOR":
        angka = 5
        data = view_all_supplier(angka)
        df = pd.DataFrame(data, columns=("ID Tabung","Nomor Tabung","Jenis Tabung","Id Supplier","Kode Supplier","Total Stock"))
        # Mengubah kolom pertama menjadi angka yang dimulai dari 1
        df.iloc[:, 0] = range(1, len(df) + 1)
        st.table(df)
    
        
# Fungsi CRUD
