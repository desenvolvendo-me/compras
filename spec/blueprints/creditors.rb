Creditor.blueprint(:sobrinho) do
  person { Person.make!(:sobrinho) }
  occupation_classification { OccupationClassification.make!(:armed_forces) }
  municipal_public_administration { false }
  autonomous { false }
  social_identification_number { "123456" }
  accounts { [ CreditorBankAccount.make!(:conta) ] }
  creditor_balances { [ CreditorBalance.make!(:balanco_2012) ] }
  regularization_or_administrative_sanctions { [ RegularizationOrAdministrativeSanction.make!(:sancao_administrativa, :creditor => object) ] }
end

Creditor.blueprint(:nohup) do
  person { Person.make!(:nohup) }
  company_size { CompanySize.make!(:micro_empresa) }
  choose_simple { false }
  main_cnae { Cnae.make!(:varejo) }
  cnaes { [ Cnae.make!(:aluguel) ] }
  documents { [ CreditorDocument.make!(:documento) ] }
  representatives { [ CreditorRepresentative.make!(:representante_sobrinho) ] }
  materials { [ Material.make!(:antivirus) ] }
  accounts { [ CreditorBankAccount.make!(:conta) ] }
  creditor_balances { [ CreditorBalance.make!(:balanco_2012) ] }
  regularization_or_administrative_sanctions { [ RegularizationOrAdministrativeSanction.make!(:sancao_administrativa, :creditor => object) ] }
end

Creditor.blueprint(:mateus) do
  person { Person.make!(:mateus) }
  accounts { [ CreditorBankAccount.make!(:conta) ] }
  creditor_balances { [ CreditorBalance.make!(:balanco_2012) ] }
  regularization_or_administrative_sanctions { [ RegularizationOrAdministrativeSanction.make!(:sancao_administrativa, :creditor => object) ] }
end
