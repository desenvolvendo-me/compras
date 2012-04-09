require 'model_helper'
require 'app/models/revenue_nature'

describe RevenueNature do
  it 'should return id as to_s' do
    subject.id = 1
    subject.to_s.should eq '1'
  end

  it { should validate_presence_of :regulatory_act }
  it { should validate_presence_of :classification }
  it { should validate_presence_of :revenue_rubric }
  it { should validate_presence_of :specification }
  it { should validate_presence_of :kind }
  it { should validate_presence_of :docket }
  it { should validate_presence_of :entity }
  it { should validate_presence_of :year }

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('2a12').for(:year) }

  it { should allow_value('12344569').for(:classification) }
  it { should_not allow_value('1234').for(:classification) }
end
