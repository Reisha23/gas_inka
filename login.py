import streamlit as st
import hashlib
import mysql.connector

# Fungsi untuk membuat koneksi ke database MySQL
def connect_to_database():
    try:
        conn = mysql.connector.connect(
            host="127.0.0.1",
            user="root",
            password="",
            database="gas_rev"
        )
        if conn.is_connected():
            return conn
    except mysql.connector.Error as e:
        st.error(f"Error connecting to MySQL database: {e}")
        return None

# Fungsi untuk melakukan query dan fetch data
def execute_query(query, params=None):
    conn = connect_to_database()
    if conn:
        cursor = conn.cursor()
        cursor.execute(query, params)
        result = cursor.fetchall()
        cursor.close()
        conn.close()
        return result
    else:
        return None

# Fungsi untuk login user
def login_user(email_user, password_user):
    query = '''
        SELECT nama_user FROM pengguna 
        WHERE email_user = %s AND password_user = MD5(%s)
    '''
    result = execute_query(query, (email_user, password_user))
    if result:
        return result[0][0]
    else:
        return None

# Login form
if 'logged_in_user' not in st.session_state:
    st.title("User Login")
    email = st.text_input("Email")
    password = st.text_input("Password", type="password")
    if st.button("Login"):
        user = login_user(email, password)
        if user:
            st.session_state.logged_in_user = user
            st.experimental_rerun()
        else:
            st.error("Invalid email or password")

    # Link ke halaman registrasi
    st.write("Belum punya akun? [Daftar di sini](register.py)")