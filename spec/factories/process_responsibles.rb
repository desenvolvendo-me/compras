# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :process_responsible do
    licitation_process nil
    stage_process nil
    employee nil
  end
end
