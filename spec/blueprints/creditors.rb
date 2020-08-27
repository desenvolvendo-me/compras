Creditor.blueprint(:sobrinho) do
  accounts { [CreditorBankAccount.make!(:conta, :creditor => object)] }
  autonomous { false }
  creditor_balances { [CreditorBalance.make!(:balanco_2012, :creditor => object)] }
  municipal_public_administration { false }
  occupation_classification { OccupationClassification.make!(:armed_forces) }
  person { Person.make!(:sobrinho) }
  regularization_or_administrative_sanctions { [RegularizationOrAdministrativeSanction.make!(:sancao_administrativa, :creditor => object)] }
  social_identification_number { "123456" }
  representatives { [CreditorRepresentative.make!(:representante_sobrinho)] }
  representative_people { [Person.make!(:wenderson)] }
end

Creditor.blueprint(:sobrinho_sa) do
  accounts { [CreditorBankAccount.make!(:conta_2, :creditor => object)] }
  autonomous { false }
  creditor_balances { [CreditorBalance.make!(:balanco_2012, :creditor => object)] }
  municipal_public_administration { false }
  occupation_classification { OccupationClassification.make!(:armed_forces) }
  person { Person.make!(:sobrinho) }
  regularization_or_administrative_sanctions { [RegularizationOrAdministrativeSanction.make!(:sancao_administrativa, :creditor => object)] }
  social_identification_number { "123456" }
  representatives { [CreditorRepresentative.make!(:representante_sobrinho)] }
  representative_people { [Person.make!(:wenderson)] }
end

Creditor.blueprint(:sobrinho_sa_without_email) do
  accounts { [CreditorBankAccount.make!(:conta, :creditor => object)] }
  autonomous { false }
  creditor_balances { [CreditorBalance.make!(:balanco_2012, :creditor => object)] }
  municipal_public_administration { false }
  occupation_classification { OccupationClassification.make!(:armed_forces) }
  person { Person.make!(:sobrinho_without_email) }
  regularization_or_administrative_sanctions { [RegularizationOrAdministrativeSanction.make!(:sancao_administrativa, :creditor => object)] }
  social_identification_number { "123456" }
  representatives { [CreditorRepresentative.make!(:representante_sobrinho)] }
  representative_people { [Person.make!(:wenderson)] }
end

Creditor.blueprint(:wenderson_sa) do
  accounts { [CreditorBankAccount.make!(:conta, :creditor => object, :number => 23456)] }
  autonomous { false }
  creditor_balances { [CreditorBalance.make!(:balanco_2012, :creditor => object)] }
  municipal_public_administration { false }
  occupation_classification { OccupationClassification.make!(:armed_forces) }
  person { Person.make!(:wenderson) }
  regularization_or_administrative_sanctions { [RegularizationOrAdministrativeSanction.make!(:sancao_administrativa, :creditor => object)] }
  social_identification_number { "123456789" }
  representatives { [CreditorRepresentative.make!(:representante_sobrinho)] }
  representative_people { [Person.make!(:sobrinho)] }
end

Creditor.blueprint(:wenderson_sa_with_user) do
  accounts { [CreditorBankAccount.make!(:conta, :creditor => object, :number => 34567)] }
  autonomous { false }
  creditor_balances { [CreditorBalance.make!(:balanco_2012, :creditor => object)] }
  municipal_public_administration { false }
  occupation_classification { OccupationClassification.make!(:armed_forces) }
  person { Person.make!(:wenderson) }
  regularization_or_administrative_sanctions { [RegularizationOrAdministrativeSanction.make!(:sancao_administrativa, :creditor => object)] }
  social_identification_number { "123456789" }
  representatives { [CreditorRepresentative.make!(:representante_sobrinho)] }
  representative_people { [Person.make!(:sobrinho)] }
end

Creditor.blueprint(:nohup) do
  accounts { [CreditorBankAccount.make!(:conta, :creditor => object, :number => 45678)] }
  cnaes { [Cnae.make!(:aluguel)] }
  creditor_balances { [CreditorBalance.make!(:balanco_2012, :creditor => object)] }
  documents { [CreditorDocument.make!(:documento)] }
  main_cnae { Cnae.make!(:varejo) }
  materials { [Material.make!(:antivirus), Material.make!(:arame_comum)] }
  person { Person.make!(:nohup) }
  regularization_or_administrative_sanctions { [RegularizationOrAdministrativeSanction.make!(:sancao_administrativa, :creditor => object)] }
  representatives { [CreditorRepresentative.make!(:representante_sobrinho)] }
  representative_people { [Person.make!(:sobrinho)] }
end

Creditor.blueprint(:nobe) do
  accounts { [CreditorBankAccount.make!(:conta, :creditor => object, :number => 2818)] }
  cnaes { [Cnae.make!(:aluguel)] }
  creditor_balances { [CreditorBalance.make!(:balanco_2012, :creditor => object)] }
  documents { [CreditorDocument.make!(:documento)] }
  main_cnae { Cnae.make!(:varejo) }
  materials { [Material.make!(:antivirus), Material.make!(:arame_comum)] }
  person { Person.make!(:nobe) }
  regularization_or_administrative_sanctions { [RegularizationOrAdministrativeSanction.make!(:sancao_administrativa, :creditor => object)] }
  representatives { [CreditorRepresentative.make!(:representante_sobrinho)] }
  representative_people { [Person.make!(:sobrinho)] }
end

Creditor.blueprint(:ibm) do
  accounts { [CreditorBankAccount.make!(:conta, :creditor => object, :number => 12348)] }
  cnaes { [Cnae.make!(:aluguel)] }
  creditor_balances { [CreditorBalance.make!(:balanco_2012, :creditor => object)] }
  documents { [CreditorDocument.make!(:documento)] }
  main_cnae { Cnae.make!(:varejo) }
  materials { [Material.make!(:antivirus), Material.make!(:arame_comum)] }
  person { Person.make!(:ibm) }
  regularization_or_administrative_sanctions { [RegularizationOrAdministrativeSanction.make!(:sancao_administrativa, :creditor => object)] }
  representatives { [CreditorRepresentative.make!(:representante_sobrinho)] }
  representative_people { [Person.make!(:sobrinho)] }
end

Creditor.blueprint(:mateus) do
  accounts { [CreditorBankAccount.make!(:conta, :creditor => object, :number => 12348)] }
  cnaes { [Cnae.make!(:aluguel)] }
  creditor_balances { [CreditorBalance.make!(:balanco_2012, :creditor => object)] }
  documents { [CreditorDocument.make!(:documento)] }
  main_cnae { Cnae.make!(:varejo) }
  materials { [Material.make!(:antivirus), Material.make!(:arame_comum)] }
  person { Person.make!(:mateus) }
  regularization_or_administrative_sanctions { [RegularizationOrAdministrativeSanction.make!(:sancao_administrativa, :creditor => object)] }
  representatives { [CreditorRepresentative.make!(:representante_sobrinho)] }
  representative_people { [Person.make!(:sobrinho)] }
end

{"person_id"=>"55014", "personable_type"=>"", "occupation_classification"=>"", "occupation_classification_id"=>"", "municipal_public_administration"=>"0", "autonomous"=>"0", "organ_responsible_for_registration"=>"", "main_cnae"=>"AGRICULTURA PECUÁRIA E SERVIÇOS RELACIONADOS", "main_cnae_id"=>"4777", "cnaes"=>"", "cnae_ids"=>["", "4780"], "materials"=>"", "material_ids"=>["", "10508"], "representative_person"=>"", "representative_person_id"=>"", "representatives_attributes"=>{"0"=>{"representative_person_id"=>"55005", "representative_person"=>"04 VENTOS EMPREENDIMENTOS IMOBILIARIOS LTDA-ME", "id"=>"34", "_destroy"=>"false"}}}
