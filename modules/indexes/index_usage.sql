SELECT
	o.Name as 'table_name',
	i.name as 'index_name',
	s.user_seeks,
	s.user_scans,
	s.user_lookups,
	s.user_updates, 
	isnull(s.last_user_seek,isnull(s.last_user_scan,s.last_User_Lookup)) Ultimo_acesso,fill_factor
FROM sys.dm_db_index_usage_stats s
JOIN sys.indexes i on i.object_id = s.object_id and i.index_id = s.index_id
JOIN sys.sysobjects o on i.object_id = o.id
WHERE s.database_id = db_id()
ORDER BY s.user_seeks + s.user_scans + s.user_lookups DESC
