Employee.blueprint(:sobrinho) do
  individual { Person.make!(:sobrinho).personable }
  position { ::FactoryGirl::Preload.factories['Position'][:gerente] }
  registration { "958473" }
end

Employee.blueprint(:wenderson) do
  individual { Person.make!(:wenderson).personable }
  position { ::FactoryGirl::Preload.factories['Position'][:gerente] }
  registration { "12903412" }
end
