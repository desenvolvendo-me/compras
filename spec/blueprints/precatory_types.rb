# encoding: utf-8

PrecatoryType.blueprint(:tipo_de_precatorio_ativo) do
  description { "Precatórios Alimentares" }
  status { Status::ACTIVE }
  deactivation_date { "" }
end

PrecatoryType.blueprint(:ordinario_demais_casos) do
  description { "Ordinário - Demais Casos" }
  status { Status::ACTIVE }
  deactivation_date { "" }
end

PrecatoryType.blueprint(:tipo_de_precatorio_inativo) do
  description { "De pequeno valor" }
  status { Status::INACTIVE }
  deactivation_date { Date.yesterday }
end
