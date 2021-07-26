# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :list_purchase_solicitation do
    licitation_process nil
    purchase_solicitation nil
    resource_source "MyString"
    balance "9.99"
    expected_value "9.99"
    consumed_value "9.99"
  end
end
