# Compras e Licitações ![](https://semaphoreapp.com/api/v1/projects/d906cde0e497abf23305c0150b4a771f1f0b4c6c/831/badge.png)

Gestão de compras e licitações do município.

## Configuração

### Git

    $ git clone git@github.com:nohupbrasil/compras.git

#### Auto-rebase

[Why?](http://stevenharman.net/blog/archive/2011/06/09/git-pull-with-automatic-rebase.aspx)

    $ git config branch.autosetuprebase always --global
    $ git config branch.master.rebase true

### PhantomJS

    $ brew install phantomjs

### Bundler

    $ bundle install

### PostgreSQL

A versão do PostgreSQL dever ser >= 9.1.

Crie um usuário chamado `compras` com permissão para criar banco de dados, ou altere o usuário do `database.yml` após executar o comando abaixo.

    $ cp config/database.sample.yml config/database.yml
    $ bundle exec rake db:create db:migrate db:test:prepare db:seed

### Servidor

Usamos a [gem foreman](https://github.com/ddollar/foreman) para subir o servidor.

Instale a gem:

    $ gem install foreman

Crie o arquivo .env no diretório do projeto com o seguinte conteúdo:

    RACK_ENV=development
    RAILS_RELATIVE_URL_ROOT=/compras
    PORT=8080

E para executar o servidor:

    $ foreman start

Feito isto o projeto estará disponível na url: http://localhost:8080/compras/

Caso não queira instalar a gem foreman você pode rodar o projeto da seguinte forma.

`$ RAILS_RELATIVE_URL_ROOT=/contabil bundle exec unicorn -p 8080`

Dica: faça um alias.

### Testes(RSpec)

Criamos uma variável de ambiente especial para quando se deseja que ao ocorrer
um erro em um teste de request salve uma screenshot da página automaticamente.

Por padrão as imagens são salvas em tmp/errors porém existem várias variáveis
de configuraçãos no ```spec/spec_helpers.rb``` relacionadas a essa funcionalidade
disponíveis

    $ SCREENSHOT=true rspec spec/requests

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
  attr_accessible :name, :birthdate, :address_attributes, :parent, :children,
                  :grandpa, :cousin, :grandson, :nephew, :work_id

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

  validates :name, :birthdate, :parent, :children, :cousin, :grandson,
            :nephew, :work, :presence => true

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

```erb
<%= f.input :name %>
```

#### Para dividir a linha em duas partes iguais

```erb
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

```erb
<div class="yui3-g">
  <div class="yui3-u-1-8">
    <%= f.input :year %>
  </div>
</div>
```

Para datas utilize a class `yui3-u-1-6`

```erb
<div class="yui3-g">
  <div class="yui3-u-1-6">
    <%= f.input :date %>
  </div>
</div>
```

Para valores, decimais, utilize a class `yui3-u-1-4`

```erb
<div class="yui3-g">
  <div class="yui3-u-1-4">
    <%= f.input :value %>
  </div>
</div>
```

Não é possível usar esse padrão quando o label for muito grande, devendo assim aumentar o tamanho do field. Se fosse 1-8 use 1-7, se for uma data com label muito grande use 1-5 ou 1-4. Etc

Fields booleanos não devem ficar na mesma linha de outros tipos de fields, podem ficar sozinho na linha ou com outros fields booleanos.

Para os demais, use o bom senso. ;)

### Mensagens de erro para validações baseadas em outros campos

A mensagem de erro deve conter a *restrição*, o *campo relacionado* e por fim o *valor do outro campo* entre parênteses, exemplo:

    "deve ser igual ou posterior a data de emissão (04/06/2012)"

#### Customizando menssagens de erro

Para validações usando métodos o `errors.add` permite que seja passada inflections:

```ruby
def value_validation(numeric_parser = ::I18n::Alchemy::NumericParser)
  return unless pledge && value

  if value > pledge_liquidation_value
    errors.add(:value, :must_not_be_greater_than_pledge_liquidation_value, :value => numeric_parser.localize(pledge_liquidation_value))
  end
end
```

No locale:

    must_not_be_greater_than_pledge_liquidation_value: "não pode ser superior a soma das liquidações do empenho (R$ %{value})"

#### Customizando mensagens com as validações do timeliness

O timeliness permite que seja customizado a mensagem de erro, exemplo:

```ruby
validates :protocol_date,
  :timeliness => {
    :on_or_after => :emission_date,
    :on_or_after_message => :should_be_on_or_after_emission_date,
    :type => :date
   }, :allow_blank => true
```

No locale precisa apenas colocar a inflection `restriction`, para o exemplo acima:

    should_be_on_or_after_emission_date: "deve ser igual ou posterior a data de emissão (%{restriction})"

### Melhorando a velocidade dos testes


#### PostgreSQL

Se seu HD não é SSD e você usa o postgres somente para testar a aplicação pode inserir as seguintes linhas no `postgresql.conf`.
Para achar esse arquivo, execute `rails db` e depois `SHOW config_file;`

  ```
    checkpoint_segments = '9'
    checkpoint_timeout = '30min'
    fsync = 'off'
    full_page_writes = 'off'
    synchronous_commit = 'off'
  ```
[Blog de referência](http://mentalized.net/journal/2012/12/07/how_we_took_our_tests_from_30_to_3_minutes/)

[Documentação oficial](http://www.postgresql.org/docs/9.2/static/non-durability.html)

#### Ruby

Requisitos:

`brew install autoconf`


Para quem usa rvm:

  ```
    curl https://raw.github.com/gist/4136373/falcon-gc.diff > $rvm_path/patches/ruby/1.9.3/p327/falcon.patch
    rvm install 1.9.3-p327 -n fast --patch falcon
    rvm use 1.9.3-p327 --default
  ```

Para quem usar rbenv:

  ```
    VERSION="1.9.3-p327"
    curl https://raw.github.com/gist/1688857/2-$VERSION-patched.sh > /tmp/$VERSION-perf
    rbenv install /tmp/$VERSION-perf
  ```

Adicione o seguinte em seu `~/.bash_profile`

  ```
    export RUBY_GC_MALLOC_LIMIT=1000000000
    export RUBY_FREE_MIN=500000
    export RUBY_HEAP_MIN_SLOTS=40000
  ```

[Referência](https://gist.github.com/burke/1688857)


