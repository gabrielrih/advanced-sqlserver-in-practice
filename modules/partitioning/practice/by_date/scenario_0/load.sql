SET NOCOUNT ON

DECLARE @RowsPerMonth AS INT = 50000
DECLARE @Month AS INT = 1
DECLARE @CurrentRow AS INT

WHILE @Month <= 12
BEGIN
	PRINT CONCAT('Inserindo ', @RowsPerMonth, ' linhas para o mês ', @Month, '/2025')

	SET @CurrentRow = 1  -- reset before each month
	WHILE @CurrentRow <= @RowsPerMonth
	BEGIN
		INSERT INTO [dbo].[Vendas] (cliente, valor, created_at)
		VALUES (
			CONCAT('Cliente_', ABS(CHECKSUM(NEWID())) % 100000), -- nome aleatório
			CAST(RAND(CHECKSUM(NEWID())) * (1000 - 10) + 10 AS DECIMAL(10,2)), -- valor aleatório
			DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 28, DATEFROMPARTS(2025, @Month, 1)) -- data no mês
		)
		SET @CurrentRow += 1
	END

	SET @Month += 1	

END

SET NOCOUNT OFF
GO

-- Verificar
SELECT MONTH(created_at) AS Mes, COUNT(*) AS Inseridos
FROM [dbo].[Vendas]
GROUP BY MONTH(created_at)
ORDER BY Mes
GO
