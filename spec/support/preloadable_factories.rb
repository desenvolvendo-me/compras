FactoryGirl.preload do
  # factory(:customer)                { create(:customer) }
  # factory(:customer)                { create(:customer, :domain => 'test.host', :name => 'Semaphore') }
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

  factory(:software)          { create(:material_class, :imported => true) }
  factory(:arames)            { create(:material_class, masked_number: "02.44.65.430.000", description: "Arames", details: "Arames de aço e ferro", has_children: true) }
  factory(:comp_eletricos)    { create(:material_class, masked_number: "03.05.33.000.00000", description: "Componentes elétricos", details: "Componentes elétricos", has_children: true) }

  factory(:rua)     { create(:street_type) }
  factory(:avenida) { create(:street_type, acronym: 'AVE', name: 'Avenida') }

  factory(:itau)      { create(:agency, bank: banks(:itau)) }
  factory(:santander) { create(:agency, digit:'5', email: 'agency_email@santander.com.br', fax:'(11) 9090-7070', name: 'Agência Santander', number: '10099', phone: '(11) 7070-7070', bank: banks(:santander)) }

  factory(:leve)  { create :risk_degree }
  factory(:medio) { create :risk_degree, level: '2', name: 'Médio'}
  factory(:grave) { create :risk_degree, level: '3', name: 'Grave'}

  factory(:general)                 { create :warehouse }
  factory(:modality_limit) { create :modality_limit }
end
