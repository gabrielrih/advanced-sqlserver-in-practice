CREATE TABLE [dbo].[Students] (
    tenant_id INT NOT NULL,
    student_id INT NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    registration_date DATE NOT NULL,
    status VARCHAR(10) NOT NULL DEFAULT 'Ativo' CHECK (status IN ('Ativo', 'Inativo', 'Trancado'))
)
GO

-- PK
-- Valores de tenant_id e student_id é controlado pela aplicação
-- Valor sequencial para evitar muita fragmentação
ALTER TABLE [dbo].[Students]
ADD CONSTRAINT [PK_Students_TenantId_StudentId] PRIMARY KEY CLUSTERED ([tenant_id], [student_id])
GO

-- Índice auxiliar busca mais comum no sistema
CREATE NONCLUSTERED INDEX [IX_Students_TenantId_FullName] ON [dbo].[Students] ([tenant_id] ASC, [full_name] ASC)
GO
