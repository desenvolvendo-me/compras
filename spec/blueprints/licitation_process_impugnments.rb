# encoding: utf-8
LicitationProcessImpugnment.blueprint(:proibido_cadeiras) do
  licitation_process_blueprint = LicitationProcess.make!(:processo_licitatorio)
  licitation_process { licitation_process_blueprint }
  impugnment_date { Date.new(2012, 4, 1) }
  related { Related::TRADING }
  person { Person.make!(:sobrinho) }
  valid_reason { "Não há a necessidade de comprar cadeiras." }
  situation { Situation::PENDING }
  judgment_date { Date.new(2012, 4, 30) }
  observation { "Nenhuma Observação" }
  envelope_delivery_date  { licitation_process_blueprint.envelope_delivery_date }
  envelope_delivery_time  { licitation_process_blueprint.envelope_delivery_time }
  envelope_opening_date   { licitation_process_blueprint.envelope_opening_date }
  envelope_opening_time   { licitation_process_blueprint.envelope_opening_time }
end