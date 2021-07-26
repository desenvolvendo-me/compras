# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :purchasing_unit do
    name "MyString"
    code 1
    starting "2019-11-19"
    situation "MyString"
    cnpj "MyString"
  end
end
