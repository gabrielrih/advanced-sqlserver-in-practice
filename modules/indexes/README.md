# Índices e a estrutura B-Tree

Um índice no SQL Server funciona como um índice em um livro — ajuda o SQL Server a encontrar dados rapidamente sem escanear toda a tabela.

A estrutura usada para organizar os dados é a B-Tree (árvore balanceada), onde:
- A raiz aponta para níveis intermediários (branches)
- Que apontam para os dados finais (leaf nodes).
- Essa estrutura permite buscas rápidas e balanceadas.

O índice clustered define a ordem física dos dados na tabela. Já os nonclustered são estruturas separadas que apontam para os dados.

## Tópicos
- O que são índices em bancos de dados relacionais
- Tipos de índices no SQL Server (Clustered vs Nonclustered)
- Como os índices aceleram consultas
- Conceito de B-Tree (Balanced Tree)
- Como os dados são organizados em uma estrutura B-Tree
- Diferença entre Seek, Scan e Lookup
- Impacto de índices mal utilizados

TO DO
