Cnae.blueprint(:aluguel) do
  code { "7739099" }
  name { "Aluguel de outras máquinas" }
  risk_degree { ::FactoryGirl::Preload.factories['RiskDegree'][:leve] }
end

Cnae.blueprint(:varejo) do
  code { "4712100" }
  name { "Comércio varejista de mercadorias em geral" }
  risk_degree { ::FactoryGirl::Preload.factories['RiskDegree'][:medio] }
end

Cnae.blueprint(:direito_social) do
  code { "94308" }
  name { "Atividades de associações de defesa de direitos sociais" }
  risk_degree { ::FactoryGirl::Preload.factories['RiskDegree'][:medio] }
end
