# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :demand do
    year 1
    description "MyString"
    observation "MyText"
    initial_date "2019-08-26"
    final_date "2019-08-26"
    status "MyString"
  end
end
