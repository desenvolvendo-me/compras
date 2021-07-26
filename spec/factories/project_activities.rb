# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project_activity do
    year "2019-11-20"
    destiny 1
    code "MyString"
    code_sub_project_activity "MyString"
  end
end
