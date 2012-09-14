# encoding: utf-8
AgreementOccurrence.blueprint(:em_andamento) do
  date { Date.new(2011, 4, 15) }
  kind { AgreementOccurrenceKind::IN_PROGRESS }
  description { 'Convênio Iniciado' }
end

AgreementOccurrence.blueprint(:other) do
  date { Date.new(2011, 3, 15) }
  kind { AgreementOccurrenceKind::OTHER }
  description { 'Convênio Iniciado' }
end

AgreementOccurrence.blueprint(:other_2) do
  date { Date.new(2012, 3, 15) }
  kind { AgreementOccurrenceKind::OTHER }
  description { 'Convênio Iniciado' }
end
