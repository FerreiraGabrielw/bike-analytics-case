CREATE TABLE gold.customers_resumo AS
SELECT
  customer_id,
  ANY_VALUE(user_id) AS user_id,
  MIN(subscription_start_date) AS first_subscription_date,
  MAX(subscription_end_date) AS last_subscription_date,
  ANY_VALUE(plan_type) AS plan_type,
  ANY_VALUE(plan_periodicity) AS plan_periodicity,
  COUNT(*) AS qtd_planos,
  MAX(plan_cost) AS max_plan_cost,
  MAX(is_first_purchase) AS is_first_purchase
FROM silver.customers
GROUP BY customer_id;


CREATE TABLE gold.faturas_agregadas AS
SELECT
  invoice_id,
  COUNT(invoice_line_id) AS qtd_itens_fatura,
  SUM(usage_fee) AS valor_total_fatura,
  ANY_VALUE(invoice_status) AS invoice_status
FROM silver.faturas
GROUP BY invoice_id;



CREATE TABLE gold.unlock_erros_agregados AS
SELECT
  user_id,
  DATE(event_timestamp) AS event_date,
  COUNT(*) AS qtd_erros_unlock
FROM silver.unlock_erros
GROUP BY user_id, event_date;


CREATE TABLE gold.viagens_consolidadas
PARTITION BY DATE(start_time) AS
SELECT
  v.trip_id,
  v.project,
  v.customer_id,
  c.user_id,
  v.start_time,
  v.end_time,
  v.duration_seconds,
  v.invoice_id,
  f.valor_total_fatura,
  f.qtd_itens_fatura,
  f.invoice_status,
  COALESCE(e.qtd_erros_unlock, 0) AS qtd_erros_unlock,
  c.plan_type,
  c.plan_periodicity,
  c.qtd_planos,
  c.max_plan_cost,
  c.is_first_purchase
FROM silver.viagens v
LEFT JOIN gold.customers_resumo c
  ON v.customer_id = c.customer_id
LEFT JOIN gold.faturas_agregadas f
  ON v.invoice_id = f.invoice_id
LEFT JOIN gold.unlock_erros_agregados e
  ON c.user_id = e.user_id
 AND DATE(v.start_time) = e.event_date;