# encoding: utf-8
Agreement.blueprint(:apoio_ao_turismo) do
  number_year { '59/2012' }
  category { AgreementCategory::REPASSED }
  agreement_kind { AgreementKind.make!(:contribuicao) }
  value { 145000.00 }
  counterpart_value { 45000.00 }
  parcels_number { 12 }
  description { "Apoio ao turismo" }
  number_year_process { '12758/2008' }
  process_date { Date.new(2012, 11, 22) }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  agreement_bank_accounts { [AgreementBankAccount.make!(:itau)] }
  agreement_occurrences { [AgreementOccurrence.make!(:em_andamento)] }
  agreement_participants { [AgreementParticipant.make!(:sobrinho), AgreementParticipant.make!(:sobrinho_granting)] }
  agreement_additives { [AgreementAdditive.make!(:termo_de_aditamento)] }
end

Agreement.blueprint(:apoio_ao_turismo_with_2_occurrences) do
  number_year { '59/2012' }
  category { AgreementCategory::REPASSED }
  agreement_kind { AgreementKind.make!(:contribuicao) }
  value { 145000.00 }
  counterpart_value { 45000.00 }
  parcels_number { 12 }
  description { "Apoio ao turismo" }
  number_year_process { '12758/2008' }
  process_date { Date.new(2012, 11, 22) }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  agreement_bank_accounts { [
    AgreementBankAccount.make!(:itau),
    AgreementBankAccount.make!(:santander)
  ] }
  agreement_occurrences { [AgreementOccurrence.make!(:em_andamento), AgreementOccurrence.make!(:other)] }
  agreement_participants { [AgreementParticipant.make!(:sobrinho), AgreementParticipant.make!(:sobrinho_granting)] }
  agreement_additives { [AgreementAdditive.make!(:termo_de_aditamento)] }
end

Agreement.blueprint(:apoio_ao_turismo_with_2_occurrences_inactive) do
  number_year { '59/2012' }
  category { AgreementCategory::REPASSED }
  agreement_kind { AgreementKind.make!(:contribuicao) }
  value { 145000.00 }
  counterpart_value { 45000.00 }
  parcels_number { 12 }
  description { "Apoio ao turismo" }
  number_year_process { '12758/2008' }
  process_date { Date.new(2012, 11, 22) }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  agreement_bank_accounts { [AgreementBankAccount.make!(:itau)] }
  agreement_occurrences { [AgreementOccurrence.make!(:em_andamento), AgreementOccurrence.make!(:other_2)] }
  agreement_participants { [AgreementParticipant.make!(:sobrinho), AgreementParticipant.make!(:sobrinho_granting)] }
  agreement_additives { [AgreementAdditive.make!(:termo_de_aditamento)] }
end

Agreement.blueprint(:apoio_ao_turismo_inactive) do
  number_year { '59/2012' }
  category { AgreementCategory::REPASSED }
  agreement_kind { AgreementKind.make!(:contribuicao) }
  value { 145000.00 }
  counterpart_value { 45000.00 }
  parcels_number { 12 }
  description { "Apoio ao turismo" }
  number_year_process { '12758/2008' }
  process_date { Date.new(2012, 11, 22) }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  agreement_bank_accounts { [AgreementBankAccount.make!(:itau)] }
  agreement_occurrences { [AgreementOccurrence.make!(:other)] }
  agreement_participants { [AgreementParticipant.make!(:sobrinho), AgreementParticipant.make!(:sobrinho_granting)] }
  agreement_additives { [AgreementAdditive.make!(:termo_de_aditamento)] }
end

Agreement.blueprint(:apoio_a_cultura) do
  number_year { '60/2012' }
  category { AgreementCategory::RECEIVED }
  agreement_kind { AgreementKind.make!(:contribuicao) }
  value { 245000.00 }
  counterpart_value { 145000.00 }
  parcels_number { 12 }
  description { "Apoio a cultura" }
  number_year_process { '127/2008' }
  process_date { Date.new(2012, 11, 22) }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  agreement_bank_accounts { [AgreementBankAccount.make!(:itau)] }
  agreement_occurrences { [AgreementOccurrence.make!(:em_andamento)] }
  agreement_participants { [AgreementParticipant.make!(:sobrinho, :value => 390000.00),
                            AgreementParticipant.make!(:sobrinho_granting, :value => 390000.00)] }
  agreement_additives { [AgreementAdditive.make!(:termo_de_aditamento)] }
end
