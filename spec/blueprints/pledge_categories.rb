PledgeCategory.blueprint(:geral) do
  description { "Geral" }
  status { PledgeCategoryStatus::ACTIVE }
end

PledgeCategory.blueprint(:auxiliar) do
  description { "Auxiliar" }
  status { PledgeCategoryStatus::ACTIVE }
end
