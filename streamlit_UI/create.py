import streamlit as st

import mysql.connector

mydb = mysql.connector.connect(
    host="localhost", user="root", password="mysql", database="e-commerce_database_010"
)
c = mydb.cursor()

def create_Customer():
    col1, col2 = st.columns(2)
    with col1:
        custid = st.text_input("Customer ID")
        FName = st.text_input("First Name")
        LName = st.text_input("Last Name")
    with col2:
        gender = st.selectbox("Gender", ["M", "F"])
        email = st.text_input("Email ID")
        phone = st.text_input("Phone number")
    if st.button("Add Customer"):
        c.execute(f"""INSERT INTO customer VALUES ("{custid}", "{FName}", "{LName}", "{gender}", "{email}", "{phone}");""")
        mydb.commit()
        st.success(f"Successfully added Customer: {FName} {LName}")

def create_Address():
    col1, col2 = st.columns(2)
    with col1:
        custid = st.text_input("Customer ID")
        idaddress = st.text_input("Address ID")
        bno = st.text_input("Bulding Number")
    with col2:
        street = st.text_input("Street")
        city = st.text_input("City")
        country = st.text_input("Country")
    if st.button("Add Address"):
        c.execute(f"""INSERT INTO address VALUES ("{idaddress}", "{custid}", "{bno}", "{street}", "{city}", "{country}");""")
        mydb.commit()
        st.success(f"Successfully added Address for {custid}")

