ProviderPartner.blueprint(:sobrinho) do
  individual { Individual.make!(:sobrinho) }
  date { Date.new(2012, 2, 25) }
  function { ProviderPartnerFunction::MEMBER }
end
