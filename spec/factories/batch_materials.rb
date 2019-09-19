# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :batch_material do
    description "MyString"
    demand_batch nil
  end
end
