# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :supply_request_item do
    authorization_quantity "MyString"
    supply_order_id "MyString"
    authorization_value "MyString"
    pledge_item_id "MyString"
    material_id "MyString"
    quantity "MyString"
  end
end
