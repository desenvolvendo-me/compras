# encoding: utf-8

Individual.blueprint(:sobrinho) do
  cpf       { '003.151.987-37' }
  mother    { 'Helena Maria' }
  birthdate { '1990-05-28' }
  gender    { Gender::MALE }
  identity  { Identity.make(:sobrinho, :individual => object) }
  address   { Address.make(:apto, :addressable => object) }
end

Individual.blueprint(:wenderson) do
  cpf       { '003.149.513-34' }
  mother    { 'Alaine Agnes' }
  birthdate { '1973-03-21' }
  gender    { Gender::MALE }
  identity  { Identity.make(:wenderson, :individual => object) }
  address   { Address.make(:apto, :addressable => object) }
end

Individual.blueprint(:joao_da_silva) do
  cpf       { '206.538.014-40' }
  mother    { 'Joana da Silva' }
  birthdate { '1950-09-21' }
  gender    { Gender::MALE }
  identity  { Identity.make(:joao_da_silva, :individual => object) }
  address   { Address.make(:apto, :addressable => object) }
end

Individual.blueprint(:pedro_dos_santos) do
  cpf       { '270.565.341-47' }
  mother    { 'Pedro dos Santos' }
  birthdate { '1950-09-21' }
  gender    { Gender::MALE }
  identity  { Identity.make(:sobrinho, :individual => object) }
  address   { Address.make(:apto, :addressable => object) }
end

Individual.blueprint(:maria_de_souza) do
  cpf       { '872.237.422-16' }
  mother    { 'Elizabeth de Souza' }
  birthdate { '1957-09-21' }
  gender    { Gender::FEMALE }
  identity  { Identity.make(:sobrinho, :individual => object) }
  address   { Address.make(:apto, :addressable => object) }
end
