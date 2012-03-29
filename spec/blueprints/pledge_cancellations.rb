PledgeCancellation.blueprint(:empenho_2012) do
  pledge { Pledge.make!(:empenho) }
  pledge_expiration { PledgeExpiration.make!(:vencimento) }
  value_canceled { 1 }
  kind { PledgeCancellationKind::TOTAL }
  value { 9.99 }
  date { Date.new(2012, 3, 28) }
  nature { PledgeCancellationNature::NORMAL }
  reason { "Motivo para o anulamento" }
end
