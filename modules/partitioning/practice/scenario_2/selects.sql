
SELECT * FROM Vendas_Partitioned_Two
WHERE id = 600001 AND created_at = '2025-01-08'

SELECT * FROM Vendas_Partitioned_Two
WHERE created_at = '2025-01-08'

SELECT * FROM Vendas_Partitioned_Two
WHERE id = 600001

SELECT * FROM Vendas_Partitioned_Two
WITH (INDEX(PK_Vendas_Partitioned_Two_id))
WHERE id = 1199999

