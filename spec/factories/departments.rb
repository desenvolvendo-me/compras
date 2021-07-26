# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :department do
    name "MyString"
    classification "MyString"
    parent_id 1
    lft 1
    rgt 1
    masked_number "MyString"
    number "MyString"
  end
end
