# encoding: utf-8
Agreement.blueprint(:apoio_ao_turismo) do
  code { 134 }
  number { 59 }
  year { 2012 }
  category { AgreementCategory::REPASSED }
  agreement_kind { AgreementKind.make!(:contribuicao) }
  value { 145000.00 }
  counterpart_value { 45000.00 }
  parcels_number { 12 }
  description { "Apoio ao turismo" }
  process_number { 12758 }
  process_year { 2008 }
  process_date { Date.new(2012, 11, 22) }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  agreement_bank_accounts { [AgreementBankAccount.make!(:itau)] }
  agreement_occurrences { [AgreementOccurrence.make!(:em_andamento)] }
  agreement_participants { [AgreementParticipant.make!(:sobrinho)] }
  agreement_additives { [AgreementAdditive.make!(:termo_de_aditamento)] }
end

Agreement.blueprint(:apoio_a_cultura) do
  code { 567 }
  number { 60 }
  year { 2012 }
  category { AgreementCategory::RECEIVED }
  agreement_kind { AgreementKind.make!(:contribuicao) }
  value { 245000.00 }
  counterpart_value { 145000.00 }
  parcels_number { 12 }
  description { "Apoio a cultura" }
  process_number { 127 }
  process_year { 2008 }
  process_date { Date.new(2012, 11, 22) }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  agreement_bank_accounts { [AgreementBankAccount.make!(:itau)] }
  agreement_occurrences { [AgreementOccurrence.make!(:em_andamento)] }
  agreement_participants { [AgreementParticipant.make!(:sobrinho)] }
  agreement_additives { [AgreementAdditive.make!(:termo_de_aditamento)] }
end
