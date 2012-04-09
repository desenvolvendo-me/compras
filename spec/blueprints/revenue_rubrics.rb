# encoding: utf-8
RevenueRubric.blueprint(:imposto_sobre_patrimonio_e_a_renda) do
  code { '2' }
  description { 'IMPOSTOS SOBRE O PATRIMÔNIO E A RENDA' }
  revenue_source { RevenueSource.make!(:impostos) }
end

RevenueRubric.blueprint(:imposto_sobre_a_producao_e_a_circulacao) do
  code { '3' }
  description { 'IMPOSTOS SOBRE A PRODUÇÃO E A CIRCULAÇÃO' }
  revenue_source { RevenueSource.make!(:impostos) }
end
