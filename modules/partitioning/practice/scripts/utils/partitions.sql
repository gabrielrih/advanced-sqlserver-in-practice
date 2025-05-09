DECLARE @TableName AS VARCHAR(30) = 'Vendas'

-- Total table rows
SELECT OBJECT_NAME(ID) As Tabela, Rows As Rows FROM sysindexes WHERE IndID IN (0,1) and OBJECT_NAME(ID) = @TableName

-- Partitioned indexes
SELECT 
	b.name AS 'table_name',
	c.name AS 'index_name',
	c.type_desc AS 'index_type',
	a.partition_number AS 'partition_number',
	a.rows AS 'rows',
	c.is_unique,
	c.is_primary_key,
	c.fill_factor
FROM sys.partitions a WITH(NOLOCK)
INNER JOIN sys.indexes c ON a.object_id = c.object_id AND a.index_id = c.index_id
INNER JOIN sys.objects b ON a.object_id = b.object_id
WHERE b.name = @TableName

GO
