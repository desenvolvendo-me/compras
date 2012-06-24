ManagementUnit.blueprint(:unidade_central) do
  descriptor { Descriptor.make!(:detran_2012) }
  description { "Unidade Central" }
  acronym { "UGC" }
  status { Status::ACTIVE }
end

ManagementUnit.blueprint(:unidade_auxiliar) do
  descriptor { Descriptor.make!(:detran_2012) }
  description { "Unidade Auxiliar" }
  acronym { "UAC" }
  status { Status::ACTIVE }
end
