# Particionamento por tenant / client

- [Cenários](#cenários)
- [Preparando o ambiente](#preparando-o-ambiente)
- [Teste de busca de dados](#teste-de-busca-de-dados)

## Cenários

Estamos simulando uma **Plataforma Educacional** que permite o cadastro de alunos, cursos, professores, entre outras coisas. Esta é uma plataforma SaaS multi-tenant comportando milhares de instituições.

Todas, ou a maioria, das buscas na base de dados utilizam o escopo de tenant (filtrando por **tenant_id**).

TO DO: Tabela de cenários aqui

Scenario 1:
- Vantagem: A distribuição de carga dos tenants será uniforme entre as partições. Isso pode ser útil no caso da quantidade de tenant ir aumentando aos poucos (começamos com poucos tenants e ir aumentando aos poucos).
- Desvantagem: Se quisermos expandir a quantidade de partições teremos problemas, pois precisaremos mudar a estrutura da tabela criando um campo novo de CHECKSUM e possivelmente teremos que mover dados entre as partições. Nesse caso, seria bom se a tivessemos uma expectativa do máximo de tenants que vamos atingir antes de optar por essa estratégia. Além disso, a aplicação deve conhecer o tenant_partition de cada tenant_id e sempre passar ambos valores nas queries. Outra desvantagem são os outliers, se eu tiver um único tenant que tem muitos alunos eu não consigo ter uma tratativa especial para ele, os dados serão salvos automaticamente na partitição definida automaticamente pelo CHECKSUM.

Scenario 2:
TO DO: Criar o partition function por range. Isso pode ser útil quando eu já tenho uma quantidade grande de tenants em uma tabela não particionada existente e quero migrar esses dados para uma tabela particionada.
CREATE PARTITION FUNCTION pf_TenantRange(INT)
AS RANGE LEFT FOR VALUES (1000, 2000, 3000, ..., 10000)

Vantagem: Se eu já souber de antemão os tenant_id que serão outliers, ou seja, os que terão mais alunos cadastrados que o normal. Eu já posso criar a PARTITION FUNCTION colocando esses tenants em uma partição exclusiva pra eles. Exemplo onde 1001 e 1002 são os tenants com muitos alunos:

CREATE PARTITION FUNCTION pf_TenantRange(INT)
AS RANGE LEFT FOR VALUES (1000, 1001, 1002, 2000, 3000, ..., 10000)

A expansão de novas partições é um pouco mais tranquila que a abordagem anterior, sem necessidade de modificar a estrutura da tabela em si.

Além disso, a aplicação não precisa controlar/conhecer nenhum campo extra, com o tenant_id o SQL Server já será possível de identificar em qual partição aqueles dados se encontram.

Desvantagem: X

CUIDADOS COM AMBAS ABORDAGENS DE PARTICIONAMENTO: Cada tenant terá uma quantidade X de alunos. Caso eu tenha muitos tenants grandes em uma mesma partição, a distribuição dos dados pode se tornar desigual. Nesse caso, no scenario 2 eu tenho a possibilidade de reorganizar o partition function / scheme e criar uma partição única para aquele tenant.


## Preparando o ambiente

```sql
CREATE DATABASE [SistemaEducativo];
GO
```


TO DO: Montando os scripts, ainda não estão prontos.

## Teste de busca de dados
TO DO
