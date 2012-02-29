ProviderPartner.blueprint(:sobrinho) do
  individual { Individual.make!(:sobrinho) }
  date { "25/02/2012" }
  function { ProviderPartnerFunction::MEMBER }
end
