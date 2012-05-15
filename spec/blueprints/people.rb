# encoding: utf-8

Person.blueprint(:sobrinho) do
  name   { "Gabriel Sobrinho" }
  phone  { '(33) 3333-3333' }
  fax    { '(33) 3333-3334' }
  mobile { '(99) 9999-9999' }
  email  { 'gabriel.sobrinho@gmail.com' }
  personable { Individual.make!(:sobrinho) }
end

Person.blueprint(:wenderson) do
  name   { "Wenderson Malheiros" }
  phone  { '(33) 3333-3333' }
  fax    { '(33) 3333-3334' }
  mobile { '(99) 9999-9999' }
  email  { 'wenderson.malheiros@gmail.com' }
  personable { Individual.make!(:wenderson) }
end

Person.blueprint(:joao_da_silva) do
  name   { "Joao da Silva" }
  phone  { '(33) 3333-3333' }
  fax    { '(33) 3333-3334' }
  mobile { '(99) 9999-9999' }
  email  { 'joao.da.silva@gmail.com' }
  personable { Individual.make!(:joao_da_silva) }
end

Person.blueprint(:pedro_dos_santos) do
  name   { "Pedro dos Santos" }
  phone  { '(33) 3333-3333' }
  fax    { '(33) 3333-3334' }
  mobile { '(99) 9999-9999' }
  email  { 'pedro.dos.santos@gmail.com' }
  personable { Individual.make!(:pedro_dos_santos) }
end

Person.blueprint(:nohup) do
  name   { "Nohup" }
  phone  { "(11) 7070-9999" }
  fax    { "(11) 7070-8888" }
  mobile { "(33) 7070-7777" }
  email  { "wenderson@gmail.com" }
  personable { Company.make!(:nohup) }
end

Person.blueprint(:mateus) do
  name   { "Mateus Lorandi" }
  phone  { "(44) 3499-9999" }
  fax    { "(44) 3499-8888" }
  mobile { "(44) 3499-7777" }
  email  { "mcomogo@gmail.com" }
  personable { SpecialEntry.make!(:especial) }
end
