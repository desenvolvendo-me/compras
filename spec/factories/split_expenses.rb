# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :split_expense do
    code "MyString"
    description "MyString"
    function_account "MyText"
    nature_expense nil
  end
end
