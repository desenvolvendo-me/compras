require 'active_resource/reflection'
require 'active_resource/associations'
require 'active_resource/localize'
require 'active_resource/parser'

module UnicoAPI
  class Consumer
    include ActiveResource::Reflection
    include ActiveResource::Localize

    # Apesar de isso já estar sendo incluido nos métodos de classe do Reflection
    # existe este mesmo método criado no UnicoAPI::Consumer que retorna uma array
    # vazio.
    # Pelo que parece o include do módulo não está sobreescrevendo o método no
    # UnicoAPI::Consumer, então precisei forçar isso aqui.
    # TODO: caso isso funcione bem no compra poderá ir para o unico-api
    def reflect_on_all_associations(macro = nil)
      reflections.values
    end
  end
end
