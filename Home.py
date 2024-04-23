import streamlit as st
from dashboard_functions import *

# Set page configuration
st.set_page_config(
    page_title="INKA Distribution Gas Dashboard",
    page_icon="🏭"
)

# Styling CSS
sidebar_style ="""
     <style>
        .sidebar .sidebar-content {
            display: flex;
            flex-direction: column;
            align-items: center;
        }
    </style>
    """
    
st.markdown(sidebar_style, unsafe_allow_html=True)

# Header
st.title("INKA Distribution Gas")
st.write("Menampilkan semua data yang diperlukan melalui filter & fitur yang tersedia.")

# Sidebar
with st.sidebar:
    #logo
    st.image("pictures/logo.png", width=128)
    
    st.subheader("filter options :")
    filter_choice = st.selectbox(
        "Filter Data", ["Gas Allocation", "Gas Demand", "Gas Allocation Demand", "Gas Supply Demand", "Mutasi by Date", "Mutasi History"], index=5)  # Memilih Mutasi History sebagai default

 # CRUD Operations
    st.subheader("edit data :")
    operation_choice = st.selectbox(
        "Choose Operation", ["Create", "Read", "Update", "Delete"])

#show tables list    
if st.button("show all table"):
    all_tables = show_all_table()
    if all_tables:
        st.write("Tables available:")
        st.table({"Daftar": all_tables})
    else:
        st.write("No tables available.")

#button view all stock   
if st.button("View All Stock"):
    all_stock_data = view_all_stock()
    if all_stock_data:
        st.write("Data Available:")
        st.table(all_stock_data)
        
        # Membuat grafik batang
        df = pd.DataFrame(all_stock_data, columns=["ID Tabung", "Jenis Tabung", "Keterangan"])
        fig = px.bar(df, x="Jenis Tabung", y="Keterangan", color="ID Tabung", title="Stok Gas Berdasarkan Jenis")
        
        # Menambah fitur indikator warna merah jika Keterangan < 80
        threshold = 5
        df['Color'] = 'green'  # Default color
        
        # Ubah warna menjadi merah jika Keterangan < 80
        df.loc[df['Keterangan'] < threshold, 'Color'] = 'red'
        
        # Membuat pesan peringatan jika stok di bawah 80
        low_stock_warning = df[df['Keterangan'] < threshold]
        if not low_stock_warning.empty:
             st.markdown(
                '<style>div[data-testid="stToast"] div div { background-color: red; }</style>',
                unsafe_allow_html=True
            )
        st.warning("Peringatan: Stok di bawah ambang batas kebutuhan.")
        st.table(low_stock_warning[['ID Tabung', 'Jenis Tabung', 'Keterangan']])
        
        fig.update_traces(marker=dict(color=df['Color']))
        st.plotly_chart(fig, use_container_width=True)  # Tampilkan grafik batang
    else:
        st.warning("No data available.")
        
# (revisi load data) Load data secara bertahap
if filter_choice in ["Gas Allocation", "Gas Allocation Demand"]:
    data = get_gas_allocation() if filter_choice == "Gas Allocation" else get_gas_allocation_demand()
elif filter_choice == "Gas Demand":
    data = get_gas_demand()
elif filter_choice == "Gas Supply Demand":
    data = get_gas_supply_demand()
elif filter_choice == "Mutasi by Date":
    data = get_mutasi_by_date()
elif filter_choice == "Mutasi History":
    data = view_mutasi_history()

# Display filtered data
display_filtered_data(filter_choice, {filter_choice: data})

# Perform CRUD operations
if operation_choice == "Create":
    st.subheader("Create New Data")
    table_name = st.text_input("Table Name")
    data = {}  # Inisialisasi dictionary untuk menyimpan data baru
    if st.button("Create Data"):
        # Panggil fungsi create_data
        create_data(table_name, data)
        
elif operation_choice == "Read":
    st.subheader("Read Data")
    table_name = st.text_input("Table Name")
    if st.button("Read Data"):
        if table_name:
            # Panggil fungsi read_data
            data = read_data(table_name)
            if data:
                st.write("Data Available:")
                st.table(pd.DataFrame(data, columns=[]))  # Sesuaikan dengan nama kolom tabel
            else:
                st.warning("No data available.")
        else:
            st.error("Please enter a table name.")
        
elif operation_choice == "Update":
    st.subheader("Update Data")
    table_name = st.text_input("Table Name")
    data = {}  # Inisialisasi dictionary untuk menyimpan data yang akan diperbarui
    condition = {}  # Inisialisasi dictionary untuk kondisi
    if st.button("Update Data"):
        # Panggil fungsi update_data
        update_data(table_name, data, condition)
        
elif operation_choice == "Delete":
    st.subheader("Delete Data")
    table_name = st.text_input("Table Name")
    condition = {}  # Inisialisasi dictionary untuk kondisi
    if st.button("Delete Data"):
        # Panggil fungsi delete_data
        delete_data(table_name, condition)

