Signature.blueprint(:gerente_sobrinho) do
  person { Person.make!(:sobrinho) }
  position { ::FactoryGirl::Preload.factories['Position'][:gerente] }
  kind { SignatureKind::MANAGER }
  start_date { Date.new(2012, 1, 1) }
  end_date { Date.new(2012, 12, 31) }
end

Signature.blueprint(:supervisor_wenderson) do
  person { Person.make!(:wenderson) }
  position { ::FactoryGirl::Preload.factories['Position'][:supervisor] }
  kind { SignatureKind::MANAGER }
  start_date { Date.new(2013, 1, 2) }
  end_date { Date.new(2013, 12, 31) }
end
