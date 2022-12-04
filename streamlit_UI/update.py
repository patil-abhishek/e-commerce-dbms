import streamlit as st
import pandas as pd
import mysql.connector

mydb = mysql.connector.connect(
    host="localhost", user="root", password="mysql", database="e-commerce_database_010"
)
c = mydb.cursor()

def update_Customer():
    c.execute("SELECT * FROM customer")
    result = c.fetchall()
    # st.write(result)
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
    with st.expander("Current Data"):
        st.dataframe(df)
    c.execute("SELECT idcustomer FROM customer")
    result = c.fetchall()
    list_of_customers = [i[0] for i in (result)]
    selected_cust = st.selectbox("Select Customer to Edit", list_of_customers)
    c.execute('SELECT * FROM customer WHERE idcustomer="{}"'.format(selected_cust))
    selected_result = c.fetchall()
    # st.write(selected_result)
    if selected_result:
        CustomerID = selected_result[0][0]
        FName = selected_result[0][1]
        LName = selected_result[0][2]
        Gender = selected_result[0][3]
        EmailID = selected_result[0][4]
        Phone = selected_result[0][5]

        # Layout of Create
        gender = ["M", "F"]
        col1, col2 = st.columns(2)
        with col1:
            new_FName = st.text_input("First Name:", FName)
            new_LName = st.text_input("Last Name:", LName)
        with col2:
            new_Gender = st.selectbox(
                "Gender", gender, index = gender.index(Gender)
            )
            new_email = st.text_input("Email", EmailID)
            new_phone = st.text_input("Phone Number", Phone)
        if st.button("Update Customer"):
            c.execute(f"""UPDATE customer SET idcustomer = "{CustomerID}", fname="{new_FName}", lname="{new_LName}", gender="{new_Gender}", email="{new_email}", phone="{new_phone}" WHERE idcustomer="{CustomerID}";""")
            mydb.commit()
            st.success(
                "Successfully updated customer details of Customer {}".format(
                    CustomerID
                )
            )
            c.execute("SELECT * FROM customer")
            result = c.fetchall()
            # st.write(result)
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
            with st.expander("Updated Data"):
                st.dataframe(df)

    