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
end
