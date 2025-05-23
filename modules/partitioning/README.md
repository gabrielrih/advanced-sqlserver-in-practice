# Particionamento

## Pré requisitos
Antes de iniciar nesse módulo é importante que você tenha claro os seguintes conceitos:
- [Filegroup / Data files](https://learn.microsoft.com/en-us/sql/relational-databases/databases/database-files-and-filegroups?view=sql-server-ver16#file-and-filegroup-fill-strategy)
- [Indexes](https://learn.microsoft.com/en-us/sql/relational-databases/indexes/indexes?view=sql-server-ver16)
- Plano de execução: index seek, index scan e key lookup.

## O que é? 

**De forma geral...**
TO DO: Conceito de particionamento como um todo

**No SQL Server...**
O particionamento divide logicamente uma tabela grande em partes menores (partições), com base em um critério, como datas ou faixas de ID. O SQL Server continua vendo a tabela como única, mas internamente sabe que os dados estão organizados por blocos separados. Isso permite operações mais rápidas e manutenção mais fácil (ex: rebuild de índice em uma única partição). Porém, para tirar o melhor proveito da estratégia, é importante que o plano de execução consiga eliminar partições não necessárias, ou seja, evitar busca de dados em todas as partições (partition elimination).

## Vantagens
- Performance
- Manutenção
- Arquivamento
TO DO

[See](https://learn.microsoft.com/en-us/sql/relational-databases/partitions/partitioned-tables-and-indexes?view=sql-server-ver16#benefits-of-partitioning)

## Componentes e conceitos
- Partition function
- Partition schema
- Filegroups
- Partitioning column
- Aligned index
- Partition elimination
MORE HERE

## Exemplos práticos
Escopo:
    - Set up: configurar uma tabela particionada e outra exatamente igual porém sem particionamento.
    - Load: Popular dados em ambas tabelas (os mesmos dados).
    - Show: Mostrar como ficou os dados na tabela particionada e como ficou na tabela não particionada.
    - Select: Executar selects na tabela particionada e na não particionada. Mostrar planos de execução e diferenças de cada uma.
    - Maintenance: Como ocorre o comportamento das manutenções para tabelas particionadas e não particionadas (reorganize/rebuild de índice).
    - House Keeping: truncate de uma partition e exclusão de uma partition.

Exemplos:
- [Particionamento por data](./practice/PARTITIONING_BY_DATE.md): created_date, inserted_at, event_time, etc.
- Particionamento por tenant/client: customer_id, tenant_id, company_id, etc.

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

## Referências
- [Documentação oficial](https://learn.microsoft.com/en-us/sql/relational-databases/partitions/partitioned-tables-and-indexes?view=sql-server-ver16)
