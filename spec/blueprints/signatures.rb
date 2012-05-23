Signature.blueprint(:gerente_sobrinho) do
  person { Person.make!(:sobrinho) }
  position { Position.make!(:gerente) }
end

Signature.blueprint(:supervisor_wenderson) do
  person { Person.make!(:wenderson) }
  position { Position.make!(:supervisor) }
end
