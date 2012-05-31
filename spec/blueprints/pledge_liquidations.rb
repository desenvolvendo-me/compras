PledgeLiquidation.blueprint(:empenho_2012) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  pledge { Pledge.make!(:empenho) }
  value { 1 }
  value { 9.99 }
  date { Date.current + 1.day }
end

PledgeLiquidation.blueprint(:liquidacao_para_dois_vencimentos) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  pledge { Pledge.make!(:empenho_com_dois_vencimentos) }
  value { 90 }
  date { Date.current + 1.day }
end

PledgeLiquidation.blueprint(:liquidacao_total) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  pledge { Pledge.make!(:empenho) }
  value { 9.99 }
  date { Date.current + 1.day }
end

PledgeLiquidation.blueprint(:liquidacao_parcial) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  pledge { Pledge.make!(:empenho) }
  value { 1 }
  date { Date.current + 1.day }
end
