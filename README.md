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
pg_restore -d portoseguro_development DIRECTORY_NAME/portoseguro_development.dump
```

> ![#f03c15](https://via.placeholder.com/15/f03c15/000000?text=+) Alterando unico_customers

```
psql -U postgres -h localhost -p 5432 -d portoseguro_development -c "DELETE FROM unico_customers;"
psql -U postgres -h localhost -p 5432 -d portoseguro_development -c "INSERT INTO unico_customers VALUES (1, 'desenvolvimento local', 'localhost', E'--- postgres://postgres:postgres@localhost:5432/portoseguro_development \n...');"
```

> ![#f03c15](https://via.placeholder.com/15/f03c15/000000?text=+) Alterando compras_users

```
 rails c
 User.where(login: 'desenvolvedor').first.update_attributes!(password: 123456, password_confirmation: 123456, activated: true)
```
### Problemas

> Active Record 4.2.1 connection adapters - error: PG::InvalidParameterValue: ERROR: invalid value for parameter "client_min_messages": "panic" HINT: Available values: debug5, debug4, debug3, debug2, debug1, log, notice, warning, error. : SET client_min_messages TO 'panic'
```
https://gist.github.com/franzejr/11a136389c772f8452109dd5a92dfb9c
```

# Aplicação

## Acessando
> rails s
```
user: desenvolvedor
pass: 123456
```

