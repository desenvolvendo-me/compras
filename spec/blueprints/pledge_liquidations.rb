# encoding: utf-8
PledgeLiquidation.blueprint(:empenho_2012) do
  pledge { Pledge.make!(:empenho) }
  value { 1 }
  date { Date.current + 1.day }
  description { 'Para empenho 2012' }
end

PledgeLiquidation.blueprint(:liquidacao_para_dois_vencimentos) do
  pledge { Pledge.make!(:empenho_com_dois_vencimentos) }
  value { 90 }
  date { Date.current + 1.day }
  description { 'Liquidação com dois vencimentos' }
end

PledgeLiquidation.blueprint(:liquidacao_total) do
  pledge { Pledge.make!(:empenho) }
  value { 9.99 }
  date { Date.current + 1.day }
  description { 'Liquidação total' }
end

PledgeLiquidation.blueprint(:liquidacao_parcial) do
  pledge { Pledge.make!(:empenho) }
  value { 1 }
  date { Date.current + 1.day }
  description { 'Liquidação parcial' }
end
