CreditorRepresentative.blueprint(:representante_sobrinho) do
  representative_person { Person.make!(:sobrinho) }
end
