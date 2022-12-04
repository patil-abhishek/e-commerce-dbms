import pandas as pd
import streamlit as st
import mysql.connector

mydb = mysql.connector.connect(
    host="localhost", user="root", password="mysql", database="e-commerce_database_010"
)
c = mydb.cursor()

def delete_Address():
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
    with st.expander("Current data"):
        st.dataframe(df)
    c.execute("SELECT idaddress, idcustomer FROM address")
    result = c.fetchall()
    list_of_address = [[i[0], i[1]] for i in (result)]
    selected_address = st.selectbox("Address to Delete", list_of_address)
    if(selected_address):
        st.warning("Do you want to delete Address{}? This action cannot be reversed!".format(selected_address))
    if st.button("DELETE"):
        c.execute('DELETE FROM address WHERE idaddress="{}"'.format(selected_address[0]))
        mydb.commit()
        st.success(f"""Address {selected_address[0]} of customer {selected_address[1]} has been deleted successfully, see Updated data below.""")
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
    with st.expander("Current data"):
        st.dataframe(df)