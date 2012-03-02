require 'model_helper'
require 'app/models/period'

describe Period do
  it 'should return unit and amount as to_s' do
    subject.unit = PeriodUnit::YEAR
    subject.amount = '1'
    subject.to_s.should eq '1 - Ano'
  end

  it { should validate_presence_of :unit }
  it { should validate_presence_of :amount }
end
