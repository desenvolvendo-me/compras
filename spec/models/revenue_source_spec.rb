require 'model_helper'
require 'app/models/revenue_source'

describe RevenueSource do
  it 'should return code as to_s' do
    subject.code = 1
    subject.to_s.should eq '1'
  end

  it { should validate_presence_of :code }
  it { should validate_presence_of :description }
  it { should validate_presence_of :revenue_subcategory }

  it { should belong_to :revenue_subcategory }
  it { should have_many(:revenue_rubrics).dependent(:restrict) }
end
