require 'model_helper'
require 'app/models/additional_credit_opening'

describe AdditionalCreditOpening do
  it 'should return year as to_s' do
    subject.year = 2012
    subject.to_s.should eq '2012'
  end

  it { should allow_value(2012).for(:year) }
  it { should_not allow_value(212).for(:year) }
  it { should_not allow_value('2a12').for(:year) }

  it { should validate_presence_of :entity }
  it { should validate_presence_of :year }
  it { should validate_presence_of :credit_type }
  it { should validate_presence_of :administractive_act }
end
