# encoding: utf-8
PledgeLiquidation.blueprint(:empenho_2012) do
  pledge { Pledge.make!(:empenho) }
  value { 1 }
  date { Date.tomorrow }
  description { 'Para empenho 2012' }
  pledge_liquidation_parcels { [PledgeLiquidationParcel.make!(:parcela_de_valor_1)] }
end

PledgeLiquidation.blueprint(:empenho_em_15_dias) do
  pledge { Pledge.make!(:empenho) }
  value { 1 }
  date { Date.current + 15.day }
  description { 'Para 15 dias' }
  pledge_liquidation_parcels { [PledgeLiquidationParcel.make!(:parcela_de_valor_1)] }
end

PledgeLiquidation.blueprint(:liquidacao_para_dois_vencimentos) do
  pledge { Pledge.make!(:empenho_com_dois_vencimentos) }
  value { 90 }
  date { Date.tomorrow }
  description { 'Liquidação com dois vencimentos' }
  pledge_liquidation_parcels {[
    PledgeLiquidationParcel.make!(:parcela_de_valor_40),
    PledgeLiquidationParcel.make!(:parcela_de_valor_50)
  ]}
end

PledgeLiquidation.blueprint(:liquidacao_total) do
  pledge { Pledge.make!(:empenho) }
  value { 9.99 }
  date { Date.tomorrow }
  description { 'Liquidação total' }
  pledge_liquidation_parcels {[
    PledgeLiquidationParcel.make!(:parcela_de_valor_9),
    PledgeLiquidationParcel.make!(:parcela_de_valor_099)
  ]}
end

PledgeLiquidation.blueprint(:liquidacao_parcial) do
  pledge { Pledge.make!(:empenho) }
  value { 1 }
  date { Date.tomorrow }
  description { 'Liquidação parcial' }
  pledge_liquidation_parcels { [PledgeLiquidationParcel.make!(:parcela_de_valor_1)] }
end
