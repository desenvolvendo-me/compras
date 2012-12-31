Signature.blueprint(:gerente_sobrinho) do
  person { Person.make!(:sobrinho) }
  position { Position.make!(:gerente) }
  kind { SignatureKind::MANAGER }
  start_date { Date.new(2012, 1, 1) }
  end_date { Date.new(2012, 12, 31) }
end

Signature.blueprint(:supervisor_wenderson) do
  person { Person.make!(:wenderson) }
  position { Position.make!(:supervisor) }
  kind { SignatureKind::MANAGER }
  start_date { Date.new(2013, 1, 2) }
  end_date { Date.new(2013, 12, 31) }
end
