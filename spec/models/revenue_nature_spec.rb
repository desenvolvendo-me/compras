require 'model_helper'
require 'app/models/revenue_nature'
require 'app/models/revenue_accounting'

describe RevenueNature do
  it 'should return id as to_s' do
    subject.specification = 'Receitas correntes'
    subject.stub(:full_code).and_return('1.0.0.0')

    subject.to_s.should eq '1.0.0.0 - Receitas correntes'
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

  it { should belong_to :entity }
  it { should belong_to :regulatory_act }
  it { should belong_to :revenue_rubric }

  it { should have_many(:revenue_accountings).dependent(:restrict) }
end
