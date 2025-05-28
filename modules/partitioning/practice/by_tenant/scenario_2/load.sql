-- Gerar 100 tenants (tenant_id incremental iniciando em 1)
WITH Tenants AS (
    SELECT TOP (100) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS tenant_id
    FROM sys.all_objects
),

-- Gerar 5.000 alunos para cada tenant (student_id incremental iniciando em 1)
StudentsPerTenant AS (
    SELECT TOP (5000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS student_id
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
)

INSERT INTO [dbo].[Students_Partitioned_Two] (tenant_id, student_id, full_name, registration_date, status)
SELECT
    t.tenant_id,
    s.student_id,
    CONCAT('Aluno_', s.student_id, '_Tenant_', t.tenant_id),
    DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 3650, GETDATE()), -- Datas variadas nos últimos 10 anos
    'Ativo'
FROM Tenants t
CROSS JOIN StudentsPerTenant s
GO

-- Verificar
SELECT tenant_id, COUNT(1) AS Students
FROM [dbo].[Students_Partitioned_Two]
GROUP BY tenant_id
ORDER BY tenant_id
GO
