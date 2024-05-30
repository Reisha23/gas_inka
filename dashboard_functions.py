import pandas as pd
import plotly.express as px
from query import *
import streamlit as st

# loading data
def load_data():
    all_stock_data = view_all_stock() #menambahkan fungsi menampilkan seluruh data stock
    masuk = gas_masuk() #menambahkan fungsi menampilkan seluruh data stock
    keluar = gas_keluar()
    return all_stock_data,gas_masuk,gas_keluar

#filtered function from sidebar
def display_filtered_data(filter_choice, filter_options):
    filtered_data = filter_options[filter_choice]

    if filter_choice == "Gas masuk":
        st.dataframe(pd.DataFrame(filtered_data, columns=[]))
        
    elif filter_choice == "Gas keluar":
        st.dataframe(pd.DataFrame(filtered_data, columns=[]))
        
# Fungsi CRUD
