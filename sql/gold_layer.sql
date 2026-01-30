CREATE TABLE gold.viagens_consolidadas AS
SELECT
  v.trip_id,
  v.project,
  v.customer_id,
  c.user_id,

  v.start_time,
  v.end_time,
  v.duration_seconds,

  v.invoice_id,

  -- FINANCEIRO
  f.valor_total_fatura,
  f.qtd_itens_fatura,
  f.invoice_status,

  -- OPERACIONAL
  IFNULL(e.qtd_erros_unlock, 0) AS qtd_erros_unlock,

  -- PERFIL DO CLIENTE
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