# encoding: utf-8
Cnae.blueprint(:aluguel) do
  code { "7739099" }
  name { "Aluguel de outras máquinas" }
  risk_degree { RiskDegree.make!(:leve) }
end

Cnae.blueprint(:varejo) do
  code { "4712100" }
  name { "Comércio varejista de mercadorias em geral" }
  risk_degree { RiskDegree.make!(:medio) }
end
