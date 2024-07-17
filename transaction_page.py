import streamlit as st
import pandas as pd
import hashlib
import mysql.connector 
from dashboard_functions import *

# Fungsi transaction
def show_transaction_page():
    # Pastikan nilai default sudah ada di st.session_state
    if 'filter_transaction' not in st.session_state:
        st.session_state.filter_transaction = "riwayat gas masuk"
    
    if 'filter_choice' not in st.session_state:
        st.session_state.filter_choice = "SIG"
    
    # Menggunakan session state untuk menyimpan nilai input pada filter transaction & filter choice
    filter_transaction = st.selectbox(
        "filter riwayat gas :", 
        ["riwayat gas masuk", "riwayat gas keluar"], 
        index=["riwayat gas masuk", "riwayat gas keluar"].index(st.session_state.filter_transaction)
    )
    if filter_transaction != st.session_state.filter_transaction:
        st.session_state.filter_transaction = filter_transaction
        st.experimental_rerun()
    
    filter_choice = st.selectbox(
        "stok gas by supplier :", 
        ["SIG", "LANGGENG", "TIRA", "SAMATOR", "BBM"],
        index=["SIG", "LANGGENG", "TIRA", "SAMATOR", "BBM"].index(st.session_state.filter_choice)
    )
    if filter_choice != st.session_state.filter_choice:
        st.session_state.filter_choice = filter_choice
        st.experimental_rerun()
    
    # Panggil fungsi untuk menampilkan data input yang difilter
    st.write("riwayat gas masuk/keluar :")
    display_filtered_data(st.session_state.filter_transaction)
    
    st.write("filter gas bedasarkan supplier :")    
    if filter_choice:
        data = display_filtered_supplier(filter_choice)
    
    st.subheader("tambahkan data :")
    st.write("pilih transaksi masuk atau keluar, setelah memilih salah satu selanjutnya anda bisa input data pada kolom dibawah! ")
    
    if 'filter_masuk' not in st.session_state:
        st.session_state.filter_masuk = True
        st.session_state.filter_keluar = False
                    
    if st.button("tambahkan gas masuk"):
        st.session_state.filter_masuk = True
        st.session_state.filter_keluar = False

    if st.button("tambahkan gas keluar"):
        st.session_state.filter_keluar = True
        st.session_state.filter_masuk = False
    
    isMasuk = st.session_state.get('filter_masuk', True)          
                                                
    display_input_data(isMasuk) 
    
    #menampilkan seluruh history dengan kolom yang telah disesuaikan
    st.subheader("histori transaksi keluar masuk gas:")
        
    all_history_data = view_all_history()
    if all_history_data:
        st.write("berikut history transaksi realtime :")
        data = view_all_history()                    
        dataFix = []
        for item in data:
            dataFix.append((item[4], item[5], item[6], item[11], item[13], item[8]))
        df = pd.DataFrame(dataFix, columns=("Tanggal", "Jenis Aktivitas", "Jumlah", "Gas", "Supplier", "User Input"))
        print(item)
        st.table(df)
        