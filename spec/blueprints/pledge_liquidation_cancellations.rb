# encoding: utf-8
PledgeLiquidationCancellation.blueprint(:empenho_2012) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  pledge { Pledge.make!(:empenho) }
  pledge_parcel { PledgeParcel.make!(:vencimento) }
  value { 1 }
  kind { PledgeLiquidationCancellationKind::PARTIAL }
  date { Date.current + 1.day }
  reason { 'Motivo para o anulamento' }
end
