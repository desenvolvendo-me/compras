# Tributário

Gestão do lançamento e arrecadação do município onde incluem gerenciamento de receitas, cálculos, lançamentos e arrecadação de tributos.

## Configuração

### Git

    $ git clone git@github.com:nohupbrasil/tributario.git

### Bundler

    $ bundle install

### PostgreSQL

Crie um usuário chamado tributario com permissão para criar banco de dados.

    $ cp config/database.sample.yml config/database.yml
    $ bundle exec rake db:create db:migrate db:test:prepare db:seed

### Servidor

    $ bundle exec unicorn -c config/unicorn.rb

## Padrões de código

### Modelos (app/models)

#### Definição de atributos

Em ordem de definição:

* attr_accessible
* attr_readonly
* attr_protected
* attr_accessor
* attr_reader
* attr_modal

Deverá ser deixado uma linha em branco entre eles e quebrar em outro método quando ultrapassar 80 caractéres (usar o bom senso).

#### Enumerations

Não sabe o que é? Dê uma olhada no repositório da [gem enumerate_it](https://github.com/cassiomarques/enumerate_it).

As definições devem ficar imediatamente abaixo dos atributos.

O método usado é o `has_enumeration_for`. Quando a Classe usada para o enumeration tem o mesmo nome do atributo, não é necessário definí-la explicitamente.


### Exemplo geral:

```ruby
class Person < ActiveRecord::Base
  attr_accessible :name, :birthdate, :address, :parent, chindren, :grandpa
  attr_accessible :cousin, :grandson, :nephew

  attr_readonly :document

  attr_protected :balance

  attr_accessor :first_name

  attr_reader :last_name

  attr_modal :name, :birthdate, :address, :parent, chindren, :grandpa

  has_enumeration_for :status, :with => PersonStatus
  has_enumeration_for :gender # Classe do enumeration também é Gender, logo, não precisa ser definido com o :with
end
```
