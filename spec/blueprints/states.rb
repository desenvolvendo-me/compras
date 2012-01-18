State.blueprint(:mg) do
  acronym { 'MG' }
  name    { 'Minas Gerais' }
  country { Country.make!(:brasil) }
end

State.blueprint(:rs) do
  acronym { 'RS' }
  name    { 'Rio Grande do Sul' }
  country { Country.make!(:brasil) }
end

State.blueprint(:pr) do
  acronym { 'PR' }
  name    { 'Parana' }
  country { Country.make!(:brasil) }
end
