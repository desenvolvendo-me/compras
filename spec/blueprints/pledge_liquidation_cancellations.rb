# encoding: utf-8
PledgeLiquidationCancellation.blueprint(:empenho_2012) do
  pledge { Pledge.make!(:empenho) }
  value { 1 }
  date { Date.current + 1.day }
  reason { 'Motivo para o anulamento' }
end
