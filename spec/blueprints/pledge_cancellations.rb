PledgeCancellation.blueprint(:empenho_2012) do
  pledge { Pledge.make!(:empenho) }
  pledge_expiration { PledgeExpiration.make!(:vencimento) }
  value_canceled { 1 }
  kind { PledgeCancellationKind::PARTIAL }
  value { 9.99 }
  date { Date.current + 1.day }
  nature { PledgeCancellationNature::NORMAL }
  reason { "Motivo para o anulamento" }
end
