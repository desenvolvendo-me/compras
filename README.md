# Documentação

# Projeto

## [Configurando](https://www.youtube.com/watch?v=qNszOG8grjM)

# Arquitetura

## [Entendendo](https://www.youtube.com/watch?v=PowNr_hFB-o)

# Database

## Root
* user: postgres
* pass: postgres

## Restaurando
```
psql -U postgres -h localhost -c "DROP DATABASE IF EXISTS portoseguro_development;"
psql -U postgres -h localhost -c "CREATE DATABASE portoseguro_development;"
psql -U postgres -h localhost -c "COMMIT;"

```
> Criando a role
```
psql -U postgres -h localhost -c "CREATE ROLE unico LOGIN PASSWORD '123456';"
psql -U postgres -h localhost -c "CREATE ROLE integra_treino LOGIN PASSWORD '123456';"
psql -U postgres -h localhost -c "ALTER USER unico WITH SUPERUSER;"
psql -U postgres -h localhost -c "ALTER USER integra_treino WITH SUPERUSER;"
psql -U postgres -h localhost -c "CREATE ROLE ggr_all WITH INHERIT NOREPLICATION CONNECTION LIMIT -1;"
psql -U postgres -h localhost -c "CREATE ROLE ggw_all WITH INHERIT NOREPLICATION CONNECTION LIMIT -1;"
```

### Pontos Importantes
>![#f03c15](https://via.placeholder.com/15/f03c15/000000?text=+) Usando o pg_restore
```
pg_restore -d arenapolis-mt DIRECTORY_NAME/portoseguro_development.dump
```

> ![#f03c15](https://via.placeholder.com/15/f03c15/000000?text=+) Alterando unico_customers

```
psql -U postgres -h localhost -c "DELETE FROM unico_customers;"
psql -U postgres -h localhost -c "INSERT INTO unico_customers VALUES (1, 'desenvolvimento local', 'localhost', E'--- postgres://postgres:postgres@localhost:5432/portoseguro_development \n...');"
