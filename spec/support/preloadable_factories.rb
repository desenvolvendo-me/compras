# encoding: utf-8
FactoryGirl.preload do
  factory(:brazil) { create(:country) }
  factory(:mg)     { create(:state, country: countries(:brazil)) }
  factory(:rs)     { create(:state, acronym: 'RS', name: 'Rio Grande do Sul', country: countries(:brazil)) }
  factory(:pr)     { create(:state, acronym: 'PR', name: 'Paraná', country: countries(:brazil)) }
end
