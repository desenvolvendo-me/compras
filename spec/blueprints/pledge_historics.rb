PledgeHistoric.blueprint(:semestral) do
  description { "Semestral" }
  entity { Entity.make!(:detran) }
  year { "2012" }
end

PledgeHistoric.blueprint(:anual) do
  description { "Anual" }
  entity { Entity.make!(:detran) }
  year { "2012" }
end
