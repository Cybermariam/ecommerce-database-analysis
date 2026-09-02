# E-Commerce Database Analysis

## Project Description

This project is a small e-commerce database built with PostgreSQL and Python.

The goal of the project is to practice database design, SQL analysis, and connecting Python applications to PostgreSQL.

The database contains customers, products, and orders, allowing different business questions to be answered using SQL.

## Technologies Used

* Python
* PostgreSQL
* SQL
* Psycopg
* python-dotenv
* Git & GitHub

## Database Structure

The database contains three main tables.

### Customers

Stores information about customers.

* customer_id
* name
* country
* age

### Products

Stores information about products.

* product_id
* product_name
* category
* price

### Orders

Stores customer purchases.

* order_id
* customer_id
* product_id
* quantity
* amount
* order_date

The `orders` table uses foreign keys to connect customers and products.

## SQL Analysis

The project uses SQL to answer questions such as:

* How many customers are in the database?
* How many products are available?
* What is the total revenue?
* Which product generated the highest revenue?
* How much revenue did each country generate?
* Which product sold the highest quantity?
* How much did each customer spend?
* What is the average order amount?
* Which customers spent more than ₦500,000?
* What are the cheapest and most expensive products?
* How much revenue did each product category generate?
* How many orders did each customer make?

The SQL queries are stored in:

`sql/analysis.sql`

## Python and PostgreSQL Integration

Python is used to connect to PostgreSQL and perform database operations.

The project demonstrates:

* Connecting Python to PostgreSQL
* Executing SQL queries from Python
* Fetching query results
* Using parameterized queries
* Inserting records
* Updating records
* Deleting records
* Committing transactions
* Rolling back failed transactions
* Handling database errors
* Closing database connections properly

The Python code is located in:

`src/main.py`

## Environment Variables

Database configuration is stored in a `.env` file rather than being written directly into the Python code.

Example:

```text
DB_HOST=localhost
DB_PORT=5432
DB_USER=your_username
DB_NAME=your_database
```

The `.env` file is excluded from Git using `.gitignore`.

## Project Structure

```text
E-commerce-database/
├── venv/
├── src/
│   └── main.py
├── sql/
│   └── analysis.sql
├── .env
├── .gitignore
├── requirements.txt
└── README.md
```

## How to Run the Project

### 1. Create and activate the virtual environment

```bash
python3 -m venv venv
source venv/bin/activate
```

### 2. Install the dependencies

```bash
pip install -r requirements.txt
```

### 3. Configure environment variables

Create a `.env` file containing the PostgreSQL database configuration.

### 4. Run the Python program

```bash
python src/main.py
```

## What I Learned

Through this project, I practiced:

* Relational database concepts
* Primary and foreign keys
* SQL queries
* Filtering and sorting
* Aggregate functions
* GROUP BY and HAVING
* JOINs
* PostgreSQL
* Python database connectivity
* Transactions
* Error handling
* Environment variables
* Basic project organization
