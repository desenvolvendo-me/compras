# encoding: utf-8
AgreementOccurrence.blueprint(:em_andamento) do
  date { Date.new(2011, 4, 15) }
  kind { AgreementOccurrenceKind::IN_PROGRESS }
  description { 'Convênio Iniciado' }
end
