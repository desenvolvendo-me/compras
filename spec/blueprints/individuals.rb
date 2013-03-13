# encoding: utf-8

Individual.blueprint(:sobrinho) do
  cpf       { '003.151.987-37' }
  mother    { 'Helena Maria' }
  birthdate { Date.new(1990, 5, 28) }
  gender    { Gender::MALE }
  identity  { Identity.make(:sobrinho, :individual => object) }
end

Individual.blueprint(:wenderson) do
  cpf       { '003.149.513-34' }
  mother    { 'Alaine Agnes' }
  birthdate { Date.new(1973, 3, 21) }
  gender    { Gender::MALE }
  identity  { Identity.make(:wenderson, :individual => object) }
end

Individual.blueprint(:joao_da_silva) do
  cpf       { '206.538.014-40' }
  mother    { 'Joana da Silva' }
  birthdate { Date.new(1950, 9, 21) }
  gender    { Gender::MALE }
  identity  { Identity.make(:joao_da_silva, :individual => object) }
end

Individual.blueprint(:pedro_dos_santos) do
  cpf       { '270.565.341-47' }
  mother    { 'Pedro dos Santos' }
  birthdate { Date.new(1950, 9, 21) }
  gender    { Gender::MALE }
  identity  { Identity.make(:sobrinho, :individual => object) }
end