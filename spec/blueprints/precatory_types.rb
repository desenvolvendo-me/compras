# encoding: utf-8

PrecatoryType.blueprint(:tipo_de_precatorio_ativo) do
  description { "Precatórios Alimentares" }
  status { PrecatoryTypeStatus::ACTIVE }
  deactivation_date { "" }
end
