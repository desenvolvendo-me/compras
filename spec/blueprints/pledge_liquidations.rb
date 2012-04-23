PledgeLiquidation.blueprint(:empenho_2012) do
  pledge { Pledge.make!(:empenho) }
  pledge_expiration { PledgeExpiration.make!(:vencimento) }
  value { 1 }
  kind { PledgeLiquidationKind::PARTIAL }
  value { 9.99 }
  date { Date.current + 1.day }
end

PledgeLiquidation.blueprint(:liquidacao_total) do
  pledge { Pledge.make!(:empenho) }
  pledge_expiration { PledgeExpiration.make!(:vencimento) }
  kind { PledgeLiquidationKind::TOTAL }
  date { Date.current + 1.day }
end

PledgeLiquidation.blueprint(:liquidacao_parcial) do
  pledge { Pledge.make!(:empenho) }
  pledge_expiration { PledgeExpiration.make!(:vencimento) }
  kind { PledgeLiquidationKind::PARTIAL }
  value { 1 }
  date { Date.current + 1.day }
end
