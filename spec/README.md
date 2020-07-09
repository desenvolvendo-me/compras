# Problemas

## Model Street

- Foi removido a validação do zip_code devido a bagunça que estão as versões da gem unico e isso está impactando
nos testes. Nesse caso as gem unico 6.4.8 ainda tem zip_code no street sendo as mais não. E existem sistemas para
um mesmo cliente com versões mais novas ai gera esse conflito.

## Postgres

### Instalar Extension

- CREATE EXTENSION unaccent;