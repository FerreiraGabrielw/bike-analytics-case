CREATE TABLE silver.viagens AS
SELECT
  CAST(trip AS STRING) AS trip_id,
  CAST(customer AS STRING) AS customer_id,
  project,
  TIMESTAMP(start_time) AS start_time,
  TIMESTAMP(end_time) AS end_time,
  CAST(duration_seconds AS INT64) AS duration_seconds,
  CAST(invoice_id AS INT64) AS invoice_id
FROM bronze.viagens
WHERE trip IS NOT NULL;



CREATE TABLE silver.customers AS
SELECT
  CAST(customer AS STRING) AS customer_id,
  CAST(user_id AS STRING) AS user_id,
  project,
  DATE(subscription_start_date) AS subscription_start_date,
  DATE(subscription_end_date) AS subscription_end_date,
  plan_type,
  plan_periodicity,
  is_customer_first_purchase AS is_first_purchase,
  SAFE_CAST(is_customer_returning AS BOOL) AS is_customer_returning,
  CAST(plan_cost AS NUMERIC) AS plan_cost,
  DATE(date_joined) AS date_joined
FROM bronze.customers;



CREATE TABLE silver.faturas AS
SELECT
  CAST(invoice_id AS INT64) AS invoice_id,
  CAST(invoice_line_id AS INT64) AS invoice_line_id,
  project,
  invoice_status,
  CAST(usage_fee AS NUMERIC) AS usage_fee
FROM bronze.faturas;


CREATE TABLE silver.unlock_erros AS
SELECT
  CAST(user_id AS STRING) AS user_id,
  project,
  TIMESTAMP(event_timestamp) AS event_timestamp,
  event_name,
  error_type
FROM bronze.unlock_erros;