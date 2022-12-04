import streamlit as st
import mysql.connector
import pandas as pd
from create import *
from delete import *
from read import *
from update import *

mydb = mysql.connector.connect(host="localhost", user="root", password="mysql", database="e-commerce_database_010")
c = mydb.cursor()


def main():
    st.title("E-commerce Database Management System - PES1UG20CS010")
    menu = ["CRUD", "Query Box"]
    choice = st.sidebar.selectbox("Menu", menu)

    if choice == "CRUD":
        st.subheader("Choose Table to perform CRUD operations")
        table = ["Customer","Order", "Product", "Order Products", "Address"]
        choice_table = st.sidebar.selectbox("Table", table)

        if choice_table == "Customer":
            st.subheader("Customer")
            operation = ["Create", "Read", "Update", "Delete"]
            choice_operation = st.sidebar.selectbox("Operation", operation)
            if choice_operation == "Create":
                create_Customer()
            elif choice_operation == "Read":
                read_Customer()
            elif choice_operation == "Update":
                update_Customer()
            # else:
            #     delete_Customer()
        elif choice_table == "Address":
            st.subheader("Address")
            operation = ["Create", "Read", "Update", "Delete"]
            choice_operation = st.sidebar.selectbox("Operation", operation)
            if choice_operation == "Create":
                create_Address()
            elif choice_operation == "Read":
                read_Address()
            # elif choice_operation == "Update":
            #     update_Address()
            else:
                delete_Address()
        elif choice_table == "Product":
            st.subheader("Product")
            operation = ["Create", "Read", "Update", "Delete"]
            choice_operation = st.sidebar.selectbox("Operation", operation)
            # if choice_operation == "Create":
            #     create_Product()
            # elif choice_operation == "Read":
            #     read_Product()
            # elif choice_operation == "Update":
            #     update_Product()
            # else:
            #     delete_Product()
        elif choice_table == "Order":
            st.subheader("Order")
            operation = ["Create", "Read", "Update", "Delete"]
            choice_operation = st.sidebar.selectbox("Operation", operation)
            # if choice_operation == "Create":
            #     create_Order()
            # elif choice_operation == "Read":
            #     read_Order()
            # elif choice_operation == "Update":
            #     update_Order()
            # else:
            #     delete_Order()
        else:
            st.subheader("Order_Product")
            operation = ["Create", "Read", "Update", "Delete"]
            choice_operation = st.sidebar.selectbox("Operation", operation)
            # if choice_operation == "Create":
            #     create_Order_Product()
            # elif choice_operation == "Read":
            #     read_Order_Product()
            # elif choice_operation == "Update":
            #     update_Order_Product()
            # else:
            #     delete_Order_Product()
    else:
        st.subheader("Query Box")
        query = st.text_area("Enter Query")
        if st.button("Execute"):
            try:
                c.execute(query)
                result = c.fetchall()
                st.success("Query Executed Successfully")
                st.dataframe(pd.DataFrame(result))
            except:
                st.warning("Something went wrong")

if __name__ == "__main__":
    main()
