Employee.blueprint(:sobrinho) do
  person { Person.make!(:sobrinho) }
  registration { "958473" }
end

Employee.blueprint(:wenderson) do
  person { Person.make!(:wenderson) }
  registration { "12903412" }
end
