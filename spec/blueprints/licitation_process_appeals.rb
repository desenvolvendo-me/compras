# encoding: utf-8
LicitationProcessAppeal.blueprint(:interposicao_processo_licitatorio) do
  licitation_process { LicitationProcess.make!(:processo_licitatorio) }
  appeal_date { Date.new(2012, 4, 10) }
  related { LicitationProcessAppealRelated::EDITAL }
  person { Person.make!(:wenderson) }
  valid_reason { "Processo de compra inválido" }
  licitation_committee_opinion { "" }
  situation { Situation::PENDING }
  new_proposal_envelope_opening_date { Date.tomorrow }
  new_proposal_envelope_opening_time { "14:00" }
end
