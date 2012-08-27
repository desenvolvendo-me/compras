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
end
