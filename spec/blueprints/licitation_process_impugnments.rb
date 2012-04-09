# encoding: utf-8
LicitationProcessImpugnment.blueprint(:proibido_cadeiras) do
  licitation_process { LicitationProcess.make!(:processo_licitatorio) }
  impugnment_date { Date.new(2012, 4, 1) }
  related { Related::TRADING }
  person { Person.make!(:sobrinho) }
  valid_resson { "Não há a necessidade de comprar cadeiras." }
  situation { Situation::PENDING }
  judgment_date { Date.new(2012, 4, 30) }
  observation { "Nenhuma Observação" }
end