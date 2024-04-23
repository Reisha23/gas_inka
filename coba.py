import streamlit as st
import sqlite3

# Koneksi ke database SQLite
conn = sqlite3.connect('database.db')
c = conn.cursor()

# Fungsi untuk menampilkan data dari database
def view_data():
    c.execute('SELECT * FROM data')
    data = c.fetchall()
    return data

# Fungsi untuk menambahkan data ke database
def add_data(name, age):
    c.execute('INSERT INTO data (name, age) VALUES (?, ?)', (name, age))
    conn.commit()
    st.success('Data berhasil ditambahkan!')

# Fungsi untuk memperbarui data di database
def update_data(name, new_age):
    c.execute('UPDATE data SET age = ? WHERE name = ?', (new_age, name))
    conn.commit()
    st.success('Data berhasil diperbarui!')

# Fungsi untuk menghapus data dari database
def delete_data(name):
    c.execute('DELETE FROM data WHERE name = ?', (name,))
    conn.commit()
    st.success('Data berhasil dihapus!')

# Tampilan aplikasi menggunakan Streamlit
st.title('Aplikasi CRUD sederhana dengan Streamlit')

menu = ['Lihat Data', 'Tambah Data', 'Perbarui Data', 'Hapus Data']
choice = st.sidebar.selectbox('Pilih Menu', menu)

if choice == 'Lihat Data':
    st.subheader('Data yang ada:')
    data = view_data()
    st.table(data)
elif choice == 'Tambah Data':
    st.subheader('Tambah Data Baru:')
    new_name = st.text_input('Nama:')
    new_age = st.number_input('Usia:')
    if st.button('Tambah'):
        add_data(new_name, new_age)
elif choice == 'Perbarui Data':
    st.subheader('Perbarui Data:')
    name_to_update = st.text_input('Nama yang ingin diperbarui:')
    new_age = st.number_input('Usia baru:')
    if st.button('Perbarui'):
        update_data(name_to_update, new_age)
elif choice == 'Hapus Data':
    st.subheader('Hapus Data:')
    name_to_delete = st.text_input('Nama yang ingin dihapus:')
    if st.button('Hapus'):
        delete_data(name_to_delete)
