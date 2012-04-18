# encoding: utf-8
LicitationProcessImpugnment.blueprint(:proibido_cadeiras) do
  licitation_process { LicitationProcess.make!(:processo_licitatorio) }
  impugnment_date { Date.new(2012, 4, 1) }
  related { Related::TRADING }
  person { Person.make!(:sobrinho) }
  valid_reason { "Não há a necessidade de comprar cadeiras." }
  situation { Situation::PENDING }
  observation { "" }
end

LicitationProcessImpugnment.blueprint(:proibido_cadeiras_deferida) do
  licitation_process { LicitationProcess.make!(:processo_licitatorio) }
  impugnment_date { Date.new(2012, 4, 1) }
  related { Related::TRADING }
  person { Person.make!(:sobrinho) }
  valid_reason { "Não há a necessidade de comprar cadeiras." }
  situation { Situation::DEFERRED }
  observation { "" }
end
