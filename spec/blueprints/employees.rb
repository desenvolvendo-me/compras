Employee.blueprint(:sobrinho) do
  individual { Person.make!(:sobrinho).personable }
  position { ::FactoryGirl::Preload.factories['Position'][:gerente] }
  registration { "958473" }
  email { "gabriel.sobrinho@gmail.com" }
  phone { "(33) 3333-3333" }
end

Employee.blueprint(:wenderson) do
  individual { Person.make!(:wenderson).personable }
  position { ::FactoryGirl::Preload.factories['Position'][:gerente] }
  registration { "12903412" }
  email { "wenderson.malheiros@gmail.com" }
  phone { "(33) 3333-3333" }
end
