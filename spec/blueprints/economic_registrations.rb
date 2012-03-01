# encoding: utf-8
EconomicRegistration.blueprint(:nohup) do
  registration { '00001' }
  person { Person.make!(:wenderson) }
end

EconomicRegistration.blueprint(:nobe) do
  registration { '00002' }
  person { Person.make!(:sobrinho) }
end

EconomicRegistration.blueprint(:nohup_office) do
  registration { '00001' }
  person { Person.make!(:nohup) }
end
