CREATE PARTITION FUNCTION pf_TenantHash(int)
AS RANGE LEFT FOR VALUES (
0, 1, 2, 3, 4, 5, 6, 7, 8, 9
)
GO

CREATE PARTITION SCHEMA ps_TenantHash
AS PARTITION pf_TenantHash ALL TO ([PRIMARY])
GO

CREATE TABLE [dbo].[Students] (
    tenant_id INT NOT NULL,
    student_id INT NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    registration_date DATE NOT NULL,
    status VARCHAR(10) NOT NULL DEFAULT 'Ativo' CHECK (status IN ('Ativo', 'Inativo', 'Trancado')),
    tenant_hash AS ABS(CHECKSUM(tenant_id)) % 10 PERSISTED
)
ON ps_TenantHash(tenant_hash)
GO

-- Pk clusterizada
-- Valores de tenant_id e student_id é controlado pela aplicação
-- Valor sequencial para evitar muita fragmentação
ALTER TABLE [dbo].[Students]
ADD CONSTRAINT [PK_Students_TenantId_StudentId] PRIMARY KEY CLUSTERED ([tenant_id], [student_id])
ON [PRIMARY]
GO

-- Índice auxiliar também particionado para permitir buscar somente por created_at
CREATE NONCLUSTERED INDEX [IX_Students_TenantId_FullName] ON [dbo].[Students] ([tenant_id] ASC, [full_name] ASC, [tenant_hash] ASC)
ON [ps_TenantHash] ([tenant_hash])
GO
