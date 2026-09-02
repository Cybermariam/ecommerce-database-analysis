import os
from dotenv import load_dotenv
import psycopg

load_dotenv()

host = os.getenv("DB_HOST")
user = os.getenv("DB_USER")
port = os.getenv("DB_PORT")
database = os.getenv("DB_NAME")
connection = psycopg.connect(
    host=host,
    port=port,
    user=user,
    dbname=database)

cursor = connection.cursor()


# --------------------------------------------------
# Query 1: Display product names and prices
# --------------------------------------------------
cursor.execute("SELECT product_name, price FROM products")
results = cursor.fetchall()
for product in results:
    print(f"{product[0]} costs {product[1]}")


# --------------------------------------------------
# Query 2: Total revenue by country
# --------------------------------------------------
cursor.execute("""
    SELECT c.country,
    SUM(o.amount) AS country_revenue
    FROM customers c
    INNER JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.country
    ORDER BY country_revenue DESC
      """)
results = cursor.fetchall()

for row in results:
    print(f"{row[0]} generated ₦{row[1]:,.2f}")


# --------------------------------------------------
# Query 3: Get orders for a specific customer
# --------------------------------------------------

customer_id = 7
cursor.execute(
    "SELECT * FROM orders WHERE customer_id=%s",
    (customer_id,)
)
results = cursor.fetchall()
for order in results:
    print(order)


# --------------------------------------------------
# Query 4: Insert a new customer
# --------------------------------------------------

customer_id = 10
name = "David"
country = "Nigeria"
age = 30

cursor.execute(
    """
    INSERT INTO customers (customer_id, name, country, age)
    VALUES (%s, %s, %s, %s)
    """,
    (customer_id, name, country, age)
)
connection.commit()


# --------------------------------------------------
# Query 4 Verification: Check the new customer
# --------------------------------------------------
cursor.execute("SELECT * FROM customers WHERE customer_id = 10")
results = cursor.fetchone()
print(results)

# --------------------------------------------------
# Query 5: Update a customer's age
# --------------------------------------------------
new_age = 31
customer_id = 10

cursor.execute("""
UPDATE customers 
SET age = %s 
WHERE customer_id = %s
""",
               (new_age, customer_id))
connection.commit()




# --------------------------------------------------
# Query 6: Delete a customer
# --------------------------------------------------
customer_id = 10

cursor.execute(
    """
    DELETE FROM customers
    WHERE customer_id = %s
    """,
    (customer_id,)
)

connection.commit()


# --------------------------------------------------
# Query 6 Verification: Check if customer was deleted
# --------------------------------------------------
cursor.execute(
    "SELECT * FROM customers WHERE customer_id = 10"
)

results = cursor.fetchone()
print(results)

# --------------------------------------------------
# Query 7: Handle database errors
# --------------------------------------------------
customer_id = 1
try:
    cursor.execute("""
    
    INSERT INTO customers(customer_id) 
    VALUES(%s)
    """,
                   (customer_id,)

    )
    connection.commit()
except psycopg.errors.UniqueViolation:
    connection.rollback()
    print(f"Customer with customer_id {customer_id} already exists")

cursor.close()
connection.close()
