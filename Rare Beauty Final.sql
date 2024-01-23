drop database RareBeauty;
CREATE DATABASE IF NOT EXISTS RareBeauty;
USE RareBeauty;


DROP TABLE IF EXISTS suppliers;
CREATE TABLE suppliers (
	supplier_id INT AUTO_INCREMENT PRIMARY KEY,
	supplier_name VARCHAR(255) NOT NULL,
	country VARCHAR(255) NOT NULL,
	city VARCHAR(255) NOT NULL,
	phone_number VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
	category_name VARCHAR(255) PRIMARY KEY,
	category_desc VARCHAR(255)
);


DROP TABLE IF EXISTS products;
CREATE TABLE products (
product_id INT AUTO_INCREMENT PRIMARY KEY,
supplier_id INT NOT NULL,
category_name VARCHAR(255) NOT NULL,
FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
product_name VARCHAR(255) NOT NULL,
price INT NOT NULL,
rating DECIMAL(2,1) NOT NULL,
FOREIGN KEY (category_name) REFERENCES categories(category_name)
);

DROP TABLE IF EXISTS shades;
CREATE TABLE shades (
	product_id INT NOT NULL,
	shade_name VARCHAR(255),
	FOREIGN KEY (product_id) REFERENCES products(product_id),
	quantity_in_stock INT NOT NULL,
	PRIMARY KEY(product_id, shade_name)
);


DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    customer_id VARCHAR(255) PRIMARY KEY,
    customer_firstname VARCHAR(255) NOT NULL ,
	customer_lastname VARCHAR(255) NOT NULL,
	dob DATE NOT NULL,
	phone_number VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL,
	country VARCHAR(255) NOT NULL,
	city VARCHAR(255) NOT NULL,
	state VARCHAR(255),
	address_line VARCHAR(255) NOT NULL
);

CREATE INDEX idx_customers_customer_firstname ON customers(customer_firstname);
CREATE INDEX idx_customers_customer_lastname ON customers(customer_lastname);


DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    employee_id VARCHAR(255) PRIMARY KEY,
    employee_firstname VARCHAR(255) NOT NULL ,
	employee_lastname VARCHAR(255) NOT NULL,
	dob DATE NOT NULL,
	email VARCHAR(255) NOT NULL,
	country VARCHAR(255) NOT NULL,
	city VARCHAR(255) NOT NULL,
    state VARCHAR(255) ,
	address_line VARCHAR(255) NOT NULL,
	job_title VARCHAR(255) NOT NULL ,
	reports_to VARCHAR(255),
	FOREIGN KEY (reports_to) REFERENCES employees(employee_id)


);


CREATE INDEX idx_employees_employee_firstname ON employees(employee_firstname);
CREATE INDEX idx_employees_employee_lastname ON employees(employee_firstname);

DROP TABLE IF EXISTs employee_phones;
CREATE TABLE employee_phones (
	employee_id  VARCHAR(255)  NOT NULL,
	phone_number VARCHAR(255) NOT NULL,
	FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
	PRIMARY KEY(employee_id, phone_number)

);

DROP TABLE IF EXISTS orders_online;
CREATE TABLE orders_online (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
	customer_id VARCHAR(255) NOT NULL,
    employee_id VARCHAR(255) NOT NULL,
    order_status VARCHAR(255) NOT NULL,
    order_date DATE NOT NULL,
	required_arrival_date DATE NOT NULL,
    payment_method VARCHAR(255) NOT NULL,
	shipped_date DATE,
    country VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
	state VARCHAR(255) ,
    adressline VARCHAR(255) NOT NULL ,
	postal_code VARCHAR(255) NOT NULL,

FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
FOREIGN KEY (employee_id) REFERENCES employees(employee_id)

);
CREATE INDEX idx_orders_online_date ON orders_online(order_date);

DROP TABLE IF EXISTS orderdetails_online;

CREATE TABLE orderdetails_online (
	order_id INT NOT NULL,
	product_id INT NOT NULL,
	shade VARCHAR(255) NOT NULL,
	quantity_ordered INT NOT NULL,
	FOREIGN KEY (product_id, shade) REFERENCES shades(product_id,shade_name),
	FOREIGN KEY (order_id) REFERENCES orders_online(order_id),
	PRIMARY KEY(order_id, product_id, shade)
);

CREATE INDEX idx_orderdetails_online_order_id ON orderdetails_online(order_id);
CREATE INDEX idx_orderdetails_online_product_id ON orderdetails_online(product_id);
CREATE INDEX idx_orderdetails_online_shade ON orderdetails_online(shade);



DROP TABLE IF EXISTS distributors;
CREATE TABLE distributors (
	distributor_name VARCHAR(255) PRIMARY KEY
   
);

DROP TABLE IF EXISTS branches;
CREATE TABLE branches (
	branch_id INT AUTO_INCREMENT PRIMARY KEY,
	distributor_name VARCHAR(255) NOT NULL,
	FOREIGN KEY (distributor_name) REFERENCES distributors(distributor_name),
	country VARCHAR(255) NOT NULL,
	city VARCHAR(255) NOT NULL,
	state VARCHAR(255),
	addressline VARCHAR(255) NOT NULL,
	postal_code VARCHAR(255) NOT NULL
);


DROP TABLE IF EXISTS branch_phones;
CREATE TABLE branch_phones (
	branch_id INT NOT NULL,
	phone_number VARCHAR(255) NOT NULL,
	FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
	PRIMARY KEY(branch_id, phone_number)

);


DROP TABLE IF EXISTS branchproducts;
CREATE TABLE branchproducts (
	branch_id INT NOT NULL,
	product_id INT NOT NULL,
	shade_name VARCHAR(255) NOT NULL,
	quantity INT NOT NULL,
	FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
	FOREIGN KEY (product_id, shade_name) REFERENCES shades(product_id,shade_name),
	PRIMARY KEY(branch_id, product_id, shade_name)
);


DROP TABLE IF EXISTS orders_physical;
CREATE TABLE orders_physical (
	order_id INT NOT NULL AUTO_INCREMENT,
	branch_id INT NOT NULL,
	order_date DATE NOT NULL,
	payment_method VARCHAR(255) NOT NULL,
	FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
	PRIMARY KEY(order_id, branch_id)

);

DROP TABLE IF EXISTS orderdetails_physical;
CREATE TABLE orderdetails_physical (
	order_id INT NOT NULL,
	product_id INT NOT NULL,
	shade VARCHAR(255) REFERENCES shades(shade_name),
	quantity_ordered INT NOT NULL,
	FOREIGN KEY (product_id, shade) REFERENCES shades(product_id,shade_name),
	FOREIGN KEY (order_id) REFERENCES orders_physical(order_id),
	PRIMARY KEY(order_id, product_id, shade)

);





