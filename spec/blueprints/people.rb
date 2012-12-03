# encoding: utf-8

Person.blueprint(:sobrinho) do
  name   { "Gabriel Sobrinho" }
  phone  { '(33) 3333-3333' }
  fax    { '(33) 3333-3334' }
  mobile { '(99) 9999-9999' }
  email  { 'gabriel.sobrinho@gmail.com' }
  personable { Individual.make!(:sobrinho) }
  address   { Address.make(:apto, :addressable => object) }
end

Person.blueprint(:sobrinho_without_email) do
  name   { "Gabriel Sobrinho SA" }
  phone  { '(33) 3333-3333' }
  fax    { '(33) 3333-3334' }
  mobile { '(99) 9999-9999' }
  email  { '' }
  personable { Individual.make!(:sobrinho) }
  address   { Address.make(:apto, :addressable => object) }
end

Person.blueprint(:wenderson) do
  name   { "Wenderson Malheiros" }
  phone  { '(33) 3333-3333' }
  fax    { '(33) 3333-3334' }
  mobile { '(99) 9999-9999' }
  email  { 'wenderson.malheiros@gmail.com' }
  personable { Individual.make!(:wenderson) }
  address   { Address.make(:apto, :addressable => object) }
end

Person.blueprint(:joao_da_silva) do
  name   { "Joao da Silva" }
  phone  { '(33) 3333-3333' }
  fax    { '(33) 3333-3334' }
  mobile { '(99) 9999-9999' }
  email  { 'joao.da.silva@gmail.com' }
  personable { Individual.make!(:joao_da_silva) }
  address   { Address.make(:apto, :addressable => object) }
end

Person.blueprint(:pedro_dos_santos) do
  name   { "Pedro dos Santos" }
  phone  { '(33) 3333-3333' }
  fax    { '(33) 3333-3334' }
  mobile { '(99) 9999-9999' }
  email  { 'pedro.dos.santos@gmail.com' }
  personable { Individual.make!(:pedro_dos_santos) }
  address   { Address.make(:apto, :addressable => object) }
end

Person.blueprint(:nohup) do
  name   { "Nohup" }
  phone  { "(11) 7070-9999" }
  fax    { "(11) 7070-8888" }
  mobile { "(33) 7070-7777" }
  email  { "wenderson@gmail.com" }
  personable { Company.make!(:nohup) }
  address   { Address.make(:apto, :addressable => object) }
end

Person.blueprint(:nobe) do
  name   { "Nobe" }
  personable { Company.make!(:nobe) }
  address   { Address.make(:apto, :addressable => object) }
end

Person.blueprint(:ibm) do
  name   { "IBM" }
  phone  { "(11) 2323-2323" }
  fax    { "(11) 2323-2424" }
  mobile { "(11) 2323-2525" }
  email  { "ibm@gmail.com" }
  personable { Company.make!(:ibm) }
  address   { Address.make(:apto, :addressable => object) }
end

Person.blueprint(:mateus) do
  name   { "Mateus Lorandi" }
  phone  { "(44) 3499-9999" }
  fax    { "(44) 3499-8888" }
  mobile { "(44) 3499-7777" }
  email  { "mcomogo@gmail.com" }
  personable { Individual.make!(:pedro_dos_santos) }
  address   { Address.make(:apto, :addressable => object) }
end

Person.blueprint(:ibrama) do
  name   { "Ibrama" }
  phone  { "(11) 7070-9991" }
  fax    { "(11) 7070-8881" }
  mobile { "(33) 7070-7771" }
  email  { "wenderson@gmail.com" }
  personable { Company.make!(:ibrama) }
  address { Address.make(:apto, :addressable => object) }
end
