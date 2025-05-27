CREATE PARTITION FUNCTION [pf_TenantPartition_ByRange](INT)
AS RANGE LEFT FOR VALUES (
    10, 20, 30, 40, 50, 60, 70, 80, 90, 100
)
GO

CREATE PARTITION SCHEME [ps_TenantPartition_ByRange]
AS PARTITION [pf_TenantPartition_ByRange] ALL TO ([PRIMARY])
GO

CREATE TABLE [dbo].[Students_Partitioned_Two] (
    [tenant_id] INT NOT NULL,
    [student_id] INT NOT NULL,
    [full_name] VARCHAR(100) NOT NULL,
    [registration_date] DATE NOT NULL,
    [status] VARCHAR(10) NOT NULL DEFAULT 'Ativo' CHECK (status IN ('Ativo', 'Inativo', 'Trancado'))
)
ON [ps_TenantPartition_ByRange]([tenant_id])
GO

-- Pk clusterizada
-- Valores de tenant_id e student_id é controlado pela aplicação
-- Valor sequencial para evitar muita fragmentação
ALTER TABLE [dbo].[Students_Partitioned_Two]
ADD CONSTRAINT [PK_Students_Partitioned_Two_TenantId_StudentId] PRIMARY KEY CLUSTERED ([tenant_id], [student_id])
ON [ps_TenantPartition_ByRange] ([tenant_id])
GO

-- Índice auxiliar também particionado para permitir filtrar por full_name
CREATE NONCLUSTERED INDEX [IX_Students_Partitioned_Two_TenantId_FullName] ON [dbo].[Students_Partitioned_Two] ([tenant_id] ASC, [full_name] ASC)
ON [ps_TenantPartition_ByRange] ([tenant_id])
GO
