USE [LojaParticionada];
GO

CREATE TABLE [dbo].[Vendas] (
    [id] INT IDENTITY(1,1) NOT NULL,
    [cliente] VARCHAR(100) NOT NULL,
    [valor] DECIMAL(10,2) NOT NULL,
    [created_at] DATE NOT NULL
) ON [PRIMARY]
GO

-- PK
ALTER TABLE [dbo].[Vendas]
ADD CONSTRAINT [PK_Vendas_Id] PRIMARY KEY CLUSTERED ([id])
ON [PRIMARY]
GO

-- Índice auxiliar
CREATE NONCLUSTERED INDEX [IX_Vendas_Created_At] ON [dbo].[Vendas] ([created_at] ASC)
ON [PRIMARY]
GO
