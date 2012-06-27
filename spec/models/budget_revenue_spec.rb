require 'model_helper'
require 'app/models/budget_revenue'

describe BudgetRevenue do
  it 'should return code as to_s' do
    subject.code = '150'
    subject.stub(:year).and_return(2012)
    subject.to_s.should eq '150/2012'
  end

  it { should belong_to :descriptor }
  it { should belong_to :revenue_nature }
  it { should belong_to :capability }

  it { should validate_presence_of :descriptor }
  it { should validate_presence_of :revenue_nature }
  it { should validate_presence_of :capability }
  it { should validate_presence_of :kind }

  it 'should validate presence of value if kind is average' do
    subject.stub(:divide?).and_return(true)
    subject.should validate_presence_of :value
  end

  it 'should not validate presence of value if kind is average' do
    subject.stub(:divide?).and_return(false)
    subject.should_not validate_presence_of :value
  end
end
