import streamlit as st
from login import login_page
from login import dashboard_page
from register import register_page

# Fungsi untuk navigasi halaman
def main():
    if 'page' not in st.session_state:
        st.session_state.page = 'login'

    if st.session_state.page == 'login':
        login_page()
    elif st.session_state.page == 'dashboard':
        dashboard_page()
    elif st.session_state.page == 'register':
        register_page()

if __name__ == "__main__":
    main()
