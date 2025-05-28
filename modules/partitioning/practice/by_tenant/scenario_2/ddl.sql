CREATE PARTITION FUNCTION [pf_TenantPartition](INT)
AS RANGE LEFT FOR VALUES (
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9
)
GO

CREATE PARTITION SCHEME [ps_TenantPartition]
AS PARTITION [pf_TenantPartition] ALL TO ([PRIMARY])
GO

CREATE TABLE [dbo].[Students_Partitioned_Two] (
    [tenant_id] INT NOT NULL,
    [student_id] INT NOT NULL,
    [full_name] VARCHAR(100) NOT NULL,
    [registration_date] DATE NOT NULL,
    [status] VARCHAR(10) NOT NULL DEFAULT 'Ativo' CHECK (status IN ('Ativo', 'Inativo', 'Trancado')),
    [tenant_partition] AS ABS(CHECKSUM(tenant_id)) % 10 PERSISTED NOT NULL
)
ON [ps_TenantPartition]([tenant_partition])
GO

-- Pk clusterizada
-- Valores de tenant_id e student_id é controlado pela aplicação
-- Valor sequencial para evitar muita fragmentação
ALTER TABLE [dbo].[Students_Partitioned_Two]
ADD CONSTRAINT [PK_Students_Partitioned_Two_TenantId_StudentId] PRIMARY KEY CLUSTERED ([tenant_id], [tenant_partition], [student_id])
ON [ps_TenantPartition] ([tenant_partition])
GO

-- Índice auxiliar também particionado para permitir filtrar por full_name
CREATE NONCLUSTERED INDEX [IX_Students_Partitioned_Two_TenantId_FullName] ON [dbo].[Students_Partitioned_Two] ([tenant_id] ASC, [tenant_partition] ASC, [full_name] ASC)
ON [ps_TenantPartition] ([tenant_partition])
GO
