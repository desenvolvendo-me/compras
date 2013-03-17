# encoding: utf-8
FactoryGirl.define do
  factory :country do
    name 'Brasil'
  end

  factory :state do
    acronym 'MG'
    name 'Minas Gerais'
  end
end
