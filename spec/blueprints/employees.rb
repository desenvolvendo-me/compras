Employee.blueprint(:sobrinho) do
  person { Person.make!(:sobrinho) }
  position { Position.make!(:gerente) }
  registration { "958473" }
end

Employee.blueprint(:wenderson) do
  person { Person.make!(:wenderson) }
  position { Position.make!(:gerente) }
  registration { "12903412" }
end

Employee.blueprint(:joao_da_silva) do
  person { Person.make!(:joao_da_silva) }
  position { Position.make!(:gerente) }
  registration { "21430921" }
end
