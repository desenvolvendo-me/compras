# encoding: utf-8
PledgeLiquidationCancellation.blueprint(:empenho_2012) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  pledge { Pledge.make!(:empenho) }
  value { 1 }
  date { Date.current + 1.day }
  reason { 'Motivo para o anulamento' }
end
