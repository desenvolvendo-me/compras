PledgeCancellation.blueprint(:empenho_2012) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  pledge { Pledge.make!(:empenho) }
  value { 1 }
  date { Date.current + 1.day }
  nature { PledgeCancellationNature::NORMAL }
  reason { "Motivo para o anulamento" }
end

PledgeCancellation.blueprint(:cancelamento_para_empenho_em_quinze_dias) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  pledge { Pledge.make!(:empenho_em_quinze_dias) }
  value { 1 }
  date { Date.current + 20.day }
  nature { PledgeCancellationNature::NORMAL }
  reason { "Motivo para o anulamento" }
end
