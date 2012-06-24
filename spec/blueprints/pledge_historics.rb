PledgeHistoric.blueprint(:semestral) do
  descriptor { Descriptor.make!(:detran_2012) }
  description { "Semestral" }
end

PledgeHistoric.blueprint(:anual) do
  descriptor { Descriptor.make!(:detran_2012) }
  description { "Anual" }
end
