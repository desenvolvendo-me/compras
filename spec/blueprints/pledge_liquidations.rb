PledgeLiquidation.blueprint(:empenho_2012) do
  pledge { Pledge.make!(:empenho) }
  pledge_expiration { PledgeExpiration.make!(:vencimento) }
  value { 1 }
  kind { PledgeLiquidationKind::PARTIAL }
  value { 9.99 }
  date { Date.current + 1.day }
end
