import streamlit as st
import pandas as pd
import mysql.connector

mydb = mysql.connector.connect(
    host="localhost", user="root", password="mysql", database="e-commerce_database_010"
)
c = mydb.cursor()

def read_Customer():
    c.execute("SELECT * FROM customer")
    result = c.fetchall()
    df = pd.DataFrame(
        result,
        columns=[
            "Customer ID",
            "First Name",
            "Last Name",
            "Gender",
            "Email ID",
            "Phone Number",
        ],
    )
    st.dataframe(df)

def read_Address():
    c.execute("SELECT * FROM address")
    result = c.fetchall()
    df = pd.DataFrame(
        result,
        columns=[
            "Address ID",
            "Customer ID",
            "Building Number",
            "Street",
            "City",
            "Country",
        ],
    )
    st.dataframe(df)
    