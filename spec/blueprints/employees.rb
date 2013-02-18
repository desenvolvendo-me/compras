Employee.blueprint(:sobrinho) do
  individual { Person.make!(:sobrinho).personable }
  position { Position.make!(:gerente) }
  registration { "958473" }
end

Employee.blueprint(:wenderson) do
  individual { Person.make!(:wenderson).personable }
  position { Position.make!(:gerente) }
  registration { "12903412" }
end

Employee.blueprint(:joao_da_silva) do
  individual { Person.make!(:joao_da_silva).personable }
  position { Position.make!(:gerente) }
  registration { "21430921" }
end
