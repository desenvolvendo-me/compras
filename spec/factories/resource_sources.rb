# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :resource_source do
    name "MyString"
    year 1
    code "MyString"
    number_convention 1
  end
end
