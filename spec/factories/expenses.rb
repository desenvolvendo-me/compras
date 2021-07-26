# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :expense do
    year "2019-11-20"
    organ nil
    purchasing_unit nil
    expense_function nil
    expense_sub_function nil
    progran nil
    project_activity nil
    nature_expense nil
    resource_source nil
    destiny 1
    destine_type "MyString"
  end
end
