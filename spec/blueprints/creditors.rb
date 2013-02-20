Creditor.blueprint(:sobrinho) do
  accounts { [ CreditorBankAccount.make!(:conta, :creditor => object) ] }
  autonomous { false }
  creditor_balances { [ CreditorBalance.make!(:balanco_2012, :creditor => object) ] }
  municipal_public_administration { false }
  occupation_classification { OccupationClassification.make!(:armed_forces) }
  person { Person.make!(:sobrinho) }
  regularization_or_administrative_sanctions { [ RegularizationOrAdministrativeSanction.make!(:sancao_administrativa, :creditor => object) ] }
  social_identification_number { "123456" }
end

Creditor.blueprint(:sobrinho_sa) do
  accounts { [ CreditorBankAccount.make!(:conta_2, :creditor => object) ] }
  autonomous { false }
  creditor_balances { [ CreditorBalance.make!(:balanco_2012, :creditor => object) ] }
  municipal_public_administration { false }
  occupation_classification { OccupationClassification.make!(:armed_forces) }
  person { Person.make!(:sobrinho) }
  regularization_or_administrative_sanctions { [ RegularizationOrAdministrativeSanction.make!(:sancao_administrativa, :creditor => object) ] }
  social_identification_number { "123456" }
end

Creditor.blueprint(:sobrinho_sa_without_email) do
  accounts { [ CreditorBankAccount.make!(:conta, :creditor => object) ] }
  autonomous { false }
  creditor_balances { [ CreditorBalance.make!(:balanco_2012, :creditor => object) ] }
  municipal_public_administration { false }
  occupation_classification { OccupationClassification.make!(:armed_forces) }
  person { Person.make!(:sobrinho_without_email) }
  regularization_or_administrative_sanctions { [ RegularizationOrAdministrativeSanction.make!(:sancao_administrativa, :creditor => object) ] }
  social_identification_number { "123456" }
end

Creditor.blueprint(:wenderson_sa) do
  accounts { [ CreditorBankAccount.make!(:conta, :creditor => object, :number => 23456) ] }
  autonomous { false }
  creditor_balances { [ CreditorBalance.make!(:balanco_2012, :creditor => object) ] }
  municipal_public_administration { false }
  occupation_classification { OccupationClassification.make!(:armed_forces) }
  person { Person.make!(:wenderson) }
  regularization_or_administrative_sanctions { [ RegularizationOrAdministrativeSanction.make!(:sancao_administrativa, :creditor => object) ] }
  social_identification_number { "123456789" }
end

Creditor.blueprint(:wenderson_sa_with_user) do
  accounts { [ CreditorBankAccount.make!(:conta, :creditor => object, :number => 34567) ] }
  autonomous { false }
  creditor_balances { [ CreditorBalance.make!(:balanco_2012, :creditor => object) ] }
  municipal_public_administration { false }
  occupation_classification { OccupationClassification.make!(:armed_forces) }
  person { Person.make!(:wenderson) }
  regularization_or_administrative_sanctions { [ RegularizationOrAdministrativeSanction.make!(:sancao_administrativa, :creditor => object) ] }
  social_identification_number { "123456789" }
  user { User.make!(:wenderson) }
end

Creditor.blueprint(:nohup) do
  accounts { [ CreditorBankAccount.make!(:conta, :creditor => object, :number => 45678) ] }
  cnaes { [ Cnae.make!(:aluguel) ] }
  creditor_balances { [ CreditorBalance.make!(:balanco_2012, :creditor => object) ] }
  documents { [ CreditorDocument.make!(:documento) ] }
  main_cnae { Cnae.make!(:varejo) }
  materials { [ Material.make!(:antivirus), Material.make!(:arame_comum) ] }
  person { Person.make!(:nohup) }
  registration_cadastral_certificates { [ RegistrationCadastralCertificate.make!(:crc, :creditor => object) ]}
  regularization_or_administrative_sanctions { [ RegularizationOrAdministrativeSanction.make!(:sancao_administrativa, :creditor => object) ] }
  representatives { [ CreditorRepresentative.make!(:representante_sobrinho) ] }
end

Creditor.blueprint(:nobe) do
  accounts { [ CreditorBankAccount.make!(:conta, :creditor => object, :number => 2818) ] }
  cnaes { [ Cnae.make!(:aluguel) ] }
  creditor_balances { [ CreditorBalance.make!(:balanco_2012, :creditor => object) ] }
  documents { [ CreditorDocument.make!(:documento) ] }
  main_cnae { Cnae.make!(:varejo) }
  materials { [ Material.make!(:antivirus), Material.make!(:arame_comum) ] }
  person { Person.make!(:nobe) }
  registration_cadastral_certificates { [ RegistrationCadastralCertificate.make!(:crc, :creditor => object) ]}
  regularization_or_administrative_sanctions { [ RegularizationOrAdministrativeSanction.make!(:sancao_administrativa, :creditor => object) ] }
  representatives { [ CreditorRepresentative.make!(:representante_sobrinho) ] }
end

Creditor.blueprint(:ibm) do
  accounts { [ CreditorBankAccount.make!(:conta, :creditor => object, :number => 12348) ] }
  cnaes { [ Cnae.make!(:aluguel) ] }
  creditor_balances { [ CreditorBalance.make!(:balanco_2012, :creditor => object) ] }
  documents { [ CreditorDocument.make!(:documento) ] }
  main_cnae { Cnae.make!(:varejo) }
  materials { [ Material.make!(:antivirus), Material.make!(:arame_comum) ] }
  person { Person.make!(:ibm) }
  registration_cadastral_certificates { [ RegistrationCadastralCertificate.make!(:crc, :creditor => object) ]}
  regularization_or_administrative_sanctions { [ RegularizationOrAdministrativeSanction.make!(:sancao_administrativa, :creditor => object) ] }
  representatives { [ CreditorRepresentative.make!(:representante_sobrinho) ] }
end

Creditor.blueprint(:mateus) do
  accounts { [ CreditorBankAccount.make!(:conta, :creditor => object, :number => 56789) ] }
  creditor_balances { [ CreditorBalance.make!(:balanco_2012, :creditor => object) ] }
  person { Person.make!(:mateus) }
  regularization_or_administrative_sanctions { [ RegularizationOrAdministrativeSanction.make!(:sancao_administrativa, :creditor => object) ] }
end
