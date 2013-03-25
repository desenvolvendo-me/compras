# encoding: utf-8
FactoryGirl.preload do
  factory(:customer)                { create(:customer) }
  factory(:customer)                { create(:customer, :domain => 'test.host', :name => 'Semaphore') }

  factory(:brazil)                  { create(:country) }
  factory(:mg)                      { create(:state, country: countries(:brazil)) }
  factory(:rs)                      { create(:state, acronym: 'RS', name: 'Rio Grande do Sul', country: countries(:brazil)) }
  factory(:pr)                      { create(:state, acronym: 'PR', name: 'Paraná'           , country: countries(:brazil)) }
  factory(:belo_horizonte)          { create(:city, state: states(:mg)) }
  factory(:porto_alegre)            { create(:city, name: 'Porto Alegre'  , state: states(:rs)) }
  factory(:curitiba)                { create(:city, name: 'Curitiba'      , state: states(:pr)) }
  factory(:leste)                   { create(:district, city: cities(:porto_alegre)) }
  factory(:centro_bh)               { create(:neighborhood, city: cities(:belo_horizonte)) }
  factory(:sao_francisco_bh)        { create(:neighborhood, name: 'São Francisco',  city: cities(:belo_horizonte)) }
  factory(:sao_francisco_curitiba)  { create(:neighborhood, name: 'São Francisco',  city: cities(:curitiba)) }
  factory(:portugal_porto_alegre)   { create(:neighborhood, name: 'Portugal',       city: cities(:porto_alegre)) }
end
