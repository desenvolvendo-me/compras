# encoding: utf-8
CheckingAccountStructure.blueprint(:fonte_recursos) do
  checking_account_of_fiscal_account { CheckingAccountOfFiscalAccount.make!(:disponibilidade_financeira) }
  name { 'Fonte de Recursos' }
  tag { 'FonteRecursos' }
  description { 'Identificação da origem dos recursos' }
  fill { 'Limite' }
  reference { 'Referente ao limite' }
  checking_account_structure_information { CheckingAccountStructureInformation.make!(:fonte_de_recursos) }
end
