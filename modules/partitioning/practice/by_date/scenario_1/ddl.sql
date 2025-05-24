USE [LojaParticionada];
GO

CREATE PARTITION FUNCTION [pf_VendasPorMes] (DATE)
AS RANGE RIGHT FOR VALUES (
    '2025-01-01', '2025-02-01', '2025-03-01', '2025-04-01',
    '2025-05-01', '2025-06-01', '2025-07-01', '2025-08-01',
	'2025-09-01', '2025-10-01', '2025-11-01', '2025-12-01'
)
GO

CREATE PARTITION SCHEME [ps_VendasPorMes]
AS PARTITION [pf_VendasPorMes] ALL TO ([PRIMARY]);
GO

CREATE TABLE [dbo].[Vendas_Partitioned_One] (
    [id] INT IDENTITY(1,1) NOT NULL,
    [cliente] VARCHAR(100) NOT NULL,
    [valor] DECIMAL(10,2) NOT NULL,
    [created_at] DATE NOT NULL
) ON [ps_VendasPorMes] ([created_at])
GO

-- Pk clusterizada e particionada
ALTER TABLE [dbo].[Vendas_Partitioned_One]
ADD CONSTRAINT [PK_Vendas_Partitioned_One_Id_Created_at] PRIMARY KEY CLUSTERED ([id], [created_at])
ON [ps_VendasPorMes] ([created_at])
GO

-- Índice auxiliar também particionado para permitir buscar somente por created_at
CREATE NONCLUSTERED INDEX [IX_Vendas_Partitioned_One_Created_At] ON [dbo].[Vendas_Partitioned_One] ([created_at] ASC)
ON [ps_VendasPorMes] ([created_at])
GO
