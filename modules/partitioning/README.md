# Particionamento

- [Pré requisitos](#pré-requisitos)
- [O que é?](#o-que-é)
- [Vantagens](#vantagens)
- [Componentes e conceitos](#componentes-e-conceitos)
- [Exemplos práticos](#exemplos-práticos)
- [Boas práticas e cuidados](#boas-práticas-e-cuidados)

## Pré requisitos
Antes de iniciar nesse módulo é importante que você tenha claro os conceitos básicos sobre [indexes](../indexes/README.md).

## O que é? 
O particionamento divide logicamente uma tabela grande em partes menores (partições), com base em um critério, como datas ou faixas de ID. O SQL Server continua vendo a tabela como única, mas internamente sabe que os dados estão organizados por blocos separados. Isso permite operações mais rápidas e manutenção mais fácil (ex: rebuild de índice em uma única partição). Porém, para tirar o melhor proveito da estratégia, é importante que o plano de execução consiga eliminar partições não necessárias, ou seja, evitar busca de dados em todas as partições (partition elimination).

## Vantagens
- **Performance**: consultas e operações mais rápidas, pois acessam apenas partições relevantes. 
- **Manutenção**: manutenção de índice realizada de forma menos custosa e mais eficiente.
- **Arquivamento**: arquivamento simplificado removendo ou movendo partições específicas com baixo impacto no banco.

[See](https://learn.microsoft.com/en-us/sql/relational-databases/partitions/partitioned-tables-and-indexes?view=sql-server-ver16#benefits-of-partitioning)

## Componentes e conceitos
- **Partition function**: define como os dados são divididos (faixas). 
- **Partition schema**: associa a função de partição a filegroups físicos. 
- **Filegroups**: unidades físicas de armazenamento.
- **Partitioning column**: coluna usada para dividir os dados. 
- **Aligned index**: índice alinhado com a partição para otimizar acessos.
- **Partition elimination**: etapa de eliminação automática de partições desnecessárias em consultas (reduzindo o escopo da busca).

[See](https://learn.microsoft.com/en-us/sql/relational-databases/partitions/partitioned-tables-and-indexes?view=sql-server-ver16#components-and-concepts)

## Exemplos práticos
- [Particionamento por data](./practice/by_date/README.md): created_date, inserted_at, event_time, etc.
- [Particionamento por tenant/client](./practice/by_tenant/README.md): customer_id, tenant_id, company_id, etc.

## Boas práticas e cuidados
- Queries mais frequentes:
    - Use a *partitioning column* SEMPRE no predicado da query (WHERE).
- Partitioning column:
    - Escolha a coluna de particionamento de forma que os dados sejam igualmente distribuídos entre as partições.
    - Péssimos candidatos:
        - Colunas com atualização frequente: email, nome, etc.
        - Skewed data: valores não distribuídos de forma equilibrada, exemplo, 90% dos dados tem o mesmo valor.
        - Colunas pouco usadas em filtros de consulta: nunca usadas no WHERE.
- Operações de index scan serão mais rápidas no particionamento quando feitas em uma única partição. Evite buscas por range que precisem acessar múltiplas partições.
- Manter ao máximo os índices secundários criados alinhados a coluna particionada.
