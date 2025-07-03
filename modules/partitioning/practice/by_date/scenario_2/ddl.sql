USE [LojaParticionada];
GO

IF NOT EXISTS (
    SELECT * FROM sys.partition_functions
    WHERE name = 'pf_VendasPorMes'
)
BEGIN
    CREATE PARTITION FUNCTION [pf_VendasPorMes] (DATE)
    AS RANGE RIGHT FOR VALUES (
        '2025-01-01', '2025-02-01', '2025-03-01', '2025-04-01',
        '2025-05-01', '2025-06-01', '2025-07-01', '2025-08-01',
        '2025-09-01', '2025-10-01', '2025-11-01', '2025-12-01'
    )
END
GO

IF NOT EXISTS (
    SELECT * FROM sys.partition_schemes
    WHERE name = 'ps_VendasPorMes'
)
BEGIN
	CREATE PARTITION SCHEME [ps_VendasPorMes]
	AS PARTITION [pf_VendasPorMes] ALL TO ([PRIMARY])
END
GO

CREATE TABLE [dbo].[Vendas_Partitioned_Two] (
    [id] INT IDENTITY(1,1) NOT NULL,
    [cliente] VARCHAR(100) NOT NULL,
    [valor] DECIMAL(10,2) NOT NULL,
    [created_at] DATE NOT NULL
) ON [ps_VendasPorMes] ([created_at])
GO

-- Índice clusterizado e particionado
CREATE CLUSTERED INDEX [IX_Vendas_Partitioned_Two_Id_Created_At] ON [dbo].[Vendas_Partitioned_Two] ([id], [created_at])
ON [ps_VendasPorMes]([created_at])
GO

-- Índice UNIQUE somente para evitar duplicidade
ALTER TABLE [dbo].[Vendas_Partitioned_Two] ADD CONSTRAINT [PK_Vendas_Partitioned_Two_Id] PRIMARY KEY NONCLUSTERED ([id] ASC)
ON [PRIMARY]
GO
