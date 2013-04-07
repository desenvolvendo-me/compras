# encoding: utf-8
FactoryGirl.define do
  factory :customer do
    name { 'Test' }
    domain { '127.0.0.1' }
    database { Customer.connection_config }
  end

  factory :country do
    name 'Brasil'
  end

  factory :state do
    acronym 'MG'
    name    'Minas Gerais'
  end

  factory :city do
    name 'Belo Horizonte'
  end

  factory :district do
    name 'Leste'
  end

  factory :neighborhood do
    name 'Centro'
  end

  factory :reference_unit do
    name    'Metro'
    acronym 'M'
  end

  factory :profile do
    name 'Gestor'
  end

  factory :position do
    name 'Gerente'
  end

  factory :condominium do
    name 'Tambuata'
    condominium_type CondominiumType::VERTICAL
  end

  factory :land_subdivision do
    name 'Solar da Serra'
  end

  factory :bank do
    name 'Itaú'
    code 341
    acronym 'IT'
  end

  factory :materials_class do
    masked_number "01.32.00.000.000"
    class_number "013200000000"
    mask "99.99.99.999.999"
    description "Software"
    details "Softwares de computador"
    has_children false
  end
end
