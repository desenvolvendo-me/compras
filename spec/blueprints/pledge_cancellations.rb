PledgeCancellation.blueprint(:empenho_2012) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  pledge { Pledge.make!(:empenho) }
  pledge_parcel { PledgeParcel.make!(:vencimento) }
  value { 1 }
  kind { PledgeCancellationKind::PARTIAL }
  value { 9.99 }
  date { Date.current + 1.day }
  nature { PledgeCancellationNature::NORMAL }
  reason { "Motivo para o anulamento" }
end
