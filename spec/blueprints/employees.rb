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