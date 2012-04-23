# encoding: utf-8
PledgeLiquidationCancellation.blueprint(:empenho_2012) do
  pledge { Pledge.make!(:empenho) }
  pledge_expiration { PledgeExpiration.make!(:vencimento) }
  value { 1 }
  kind { PledgeLiquidationCancellationKind::PARTIAL }
  value { 9.99 }
  date { Date.current + 1.day }
  reason { 'Motivo para o anulamento' }
end
