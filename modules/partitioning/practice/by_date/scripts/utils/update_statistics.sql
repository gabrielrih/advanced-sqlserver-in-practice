/*
    Gera o comando para atualizar TODAS AS STATISTICS
*/
DECLARE @comando_update nvarchar(300)

DECLARE cursor_estatisticas CURSOR FOR
SELECT 'UPDATE STATISTICS ['+ OBJECT_NAME(id) + '] [' + name + '] WITH FULLSCAN'
FROM sys.sysindexes
WHERE id IN (SELECT object_id FROM sys.tables)
  
OPEN cursor_estatisticas;
FETCH NEXT FROM cursor_estatisticas INTO @comando_update;
  
WHILE (@@FETCH_STATUS<> -1)
BEGIN
	PRINT @comando_update;
	FETCH NEXT FROM cursor_estatisticas INTO @comando_update;
END
  
CLOSE cursor_estatisticas;
DEALLOCATE cursor_estatisticas;
GO
