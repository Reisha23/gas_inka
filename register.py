import streamlit as st
import hashlib
from login import connect_to_database

# Fungsi untuk menyimpan data pengguna baru ke database
def register_user(nama_user, email_user, password_user):
    hashed_password = hashlib.md5(password_user.encode()).hexdigest()
    query = '''
        INSERT INTO pengguna (nama_user, email_user, password_user) 
        VALUES (%s, %s, %s)
    '''
    conn = connect_to_database()
    if conn:
        cursor = conn.cursor()
        try:
            cursor.execute(query, (nama_user, email_user, hashed_password))
            conn.commit()
            st.success("Registrasi berhasil. lanjutkan untuk login.")
        except mysql.connector.Error as e:
            st.error(f"Error: {e}")
        finally:
            cursor.close()
            conn.close()
    else:
        st.error("Koneksi ke database gagal.")

# Halaman registrasi
def register_page():
    st.title("User Registration")
    nama_user = st.text_input("Nama")
    email_user = st.text_input("Email")
    password_user = st.text_input("Password", type="password")
    confirm_password = st.text_input("Confirm Password", type="password")

    if st.button("Register"):
        if password_user == confirm_password:
            register_user(nama_user, email_user, password_user)
        else:
            st.error("Passwords do not match. Please try again.")

    if st.button("Back to Login"):
        st.session_state.page = 'login'
        st.experimental_rerun()
