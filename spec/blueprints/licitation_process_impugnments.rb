# encoding: utf-8
LicitationProcessImpugnment.blueprint(:proibido_cadeiras) do
  licitation_process { LicitationProcess.make!(:processo_licitatorio) }
  impugnment_date { Date.new(2012, 4, 1) }
  related { Related::TRADING }
  person { Person.make!(:sobrinho) }
  valid_reason { "Não há a necessidade de comprar cadeiras." }
  situation { Situation::PENDING }
  judgment_date { Date.new(2012, 4, 30) }
  observation { "Nenhuma Observação" }
  envelope_delivery_date  { object.licitation_process.envelope_delivery_date }
  envelope_delivery_time  { object.licitation_process.envelope_delivery_time }
  envelope_opening_date   { object.licitation_process.envelope_opening_date }
  envelope_opening_time   { object.licitation_process.envelope_opening_time }
end
