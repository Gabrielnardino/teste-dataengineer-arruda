CREATE SCHEMA IF NOT EXISTS bronze;
CREATE TABLE bronze.raw_customers (
    customer_id character varying(5),
    company_name character varying(40),
    contact_name character varying(30),
    contact_title character varying(30),
    address character varying(60),
    city character varying(15),
    region character varying(15),
    postal_code character varying(10),
    country character varying(15),
    phone character varying(24),
    fax character varying(24)
);
CREATE TABLE bronze.raw_orders (
    order_id smallint,
    customer_id character varying(5),
    employee_id smallint,
    order_date date,
    required_date date,
    shipped_date date,
    ship_via smallint,
    freight real,
    ship_name character varying(40),
    ship_address character varying(60),
    ship_city character varying(15),
    ship_region character varying(15),
    ship_postal_code character varying(10),
    ship_country character varying(15)
);
CREATE TABLE bronze.raw_order_details (
    order_id smallint,
    product_id smallint,
    unit_price real,
    quantity smallint,
    discount real
);
CREATE TABLE bronze.raw_products (
    product_id smallint,
    product_name character varying(40),
    supplier_id smallint,
    category_id smallint,
    quantity_per_unit character varying(20),
    unit_price real,
    units_in_stock smallint,
    units_on_order smallint,
    reorder_level smallint,
    discontinued integer
);