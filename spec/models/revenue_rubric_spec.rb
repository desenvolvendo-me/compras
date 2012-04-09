require 'model_helper'
require 'app/models/revenue_rubric'
require 'app/models/revenue_nature'

describe RevenueRubric do
  it 'should return code as to_s' do
    subject.code = 1
    subject.to_s.should eq '1'
  end

  it { should validate_presence_of :code }
  it { should validate_presence_of :description }
  it { should validate_presence_of :revenue_source }

  it { should belong_to :revenue_source }
  it { should have_many(:revenue_natures).dependent(:restrict) }
end
