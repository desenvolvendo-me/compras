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

  factory(:metro)   { create :reference_unit }
  factory(:unidade) { create :reference_unit, name: 'Unidade', acronym: 'UN' }

  factory(:manager) { create :profile }

  factory(:gerente)    { create :position }
  factory(:supervisor) { create :position, name: 'Supervisor' }

  factory(:tambuata)          { create :condominium }
  factory(:parque_das_flores) { create :condominium, name: 'Parque das Flores', condominium_type: CondominiumType::HORIZONTAL }

  factory(:solar_da_serra)    { create :land_subdivision }
  factory(:horizonte_a_vista) { create :land_subdivision, name: 'Horizonte a Vista' }

  factory(:itau)      { create :bank }
  factory(:santander) { create :bank, name: 'Santander', code: 33, acronym: 'ST' }
end
