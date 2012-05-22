Signature.blueprint(:gerente_sobrinho) do
  person { Person.make!(:sobrinho) }
  position { Position.make!(:gerente) }
end
