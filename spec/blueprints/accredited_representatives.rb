AccreditedRepresentative.blueprint(:wenderson) do
  accreditation { Accreditation.make!(:credenciamento) }
  individual { Individual.make!(:wenderson) }
  provider { Provider.make!(:wenderson_sa) }
  role { "Gerente" }
end
