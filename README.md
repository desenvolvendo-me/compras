# Compras e Licitações

Gestão de compras e licitações do município.

## Configuração

### Git

    $ git clone git@github.com:nohupbrasil/compras.git

#### Auto-rebase

[Why?](http://stevenharman.net/blog/archive/2011/06/09/git-pull-with-automatic-rebase.aspx)

     $ git config branch.autosetuprebase always --global
     $ git config branch.master.rebase true

### Qt

Instale o Qt:
https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit

### Bundler

    $ bundle install

### PostgreSQL

A versão do PostgreSQL dever ser >= 9.1.

Crie um usuário chamado `compras` com permissão para criar banco de dados.

    $ cp config/database.sample.yml config/database.yml
    $ bundle exec rake db:create db:migrate db:test:prepare db:seed

### Servidor

    $ bundle exec unicorn

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

Nesse exemplo geral mostra o padrão para a ordem das definições e espaçamento dentro do model.

```ruby
class Person < ActiveRecord::Base
  attr_accessible :name, :birthdate, :address_attributes, :parent, :chindren, :grandpa
  attr_accessible :cousin, :grandson, :nephew, :work_id

  attr_readonly :document

  attr_protected :balance

  attr_accessor :first_name

  attr_reader :last_name

  attr_modal :name, :birthdate, :parent, :chindren, :grandpa

  has_enumeration_for :status, :with => PersonStatus
  has_enumeration_for :gender # Classe do enumeration também é Gender, logo, não precisa ser definido com o :with

  belongs_to :work

  has_and_belongs_to_many :whatever

  has_many :cars
  has_many :motorcycles

  has_one :wife

  accepts_nested_attributes_for :address

  delegate :company_name, :to => :work

  validates :name, :presence => true

  before_save :mount_name

  orderize
  filterize

  scope :search_by_parent, lambda { |term| where { parent.eq(term) } }

  def self.search_by_name(term)
    where { name.eq(term) }
  end

  def to_s
    name
  end

  protected

  def mount_name
    self.name = first_name
  end
end
```

### Sistema de Grids e Units para as views:

Utilizamos o sistema de grids [YUI](http://yuilibrary.com/yui/docs/cssgrids/), o exemplo mais simples para utilização é o seguinte:

#### Para um field ocupar a linha inteira não precisa fazer nada. :P

```
<%= f.input :name %>
```

#### Para dividir a linha em duas partes iguais

```
<div class="yui3-g">
  <div class="yui3-u-1-2">
    <%= f.input :name %>
  </div>

  <div class="yui3-u-1-2">
    <%= f.input :description %>
  </div>
</div>

```

#### Boas práticas

Sempre que possível utilize o seguinte padrão:

Para ano utilize a class `yui3-u-1-8`

```
<div class="yui3-g">
  <div class="yui3-u-1-8">
    <%= f.input :year %>
  </div>
</div>
```

Para datas utilize a class `yui3-u-1-6`

```
<div class="yui3-g">
  <div class="yui3-u-1-6">
    <%= f.input :date %>
  </div>
</div>
```

Para valores, decimais, utilize a class `yui3-u-1-4`

```
<div class="yui3-g">
  <div class="yui3-u-1-4">
    <%= f.input :value %>
  </div>
</div>
```

Não é possível usar esse padrão quando o label for muito grande, devendo assim aumentar o tamanho do field. Se fosse 1-8 use 1-7, se for uma data com label muito grande use 1-5 ou 1-4. Etc

Fields booleanos não devem ficar na mesma linha de outros tipos de fields, podem ficar sozinho na linha ou com outros fields booleanos.

Para os demais, use o bom senso. ;)
