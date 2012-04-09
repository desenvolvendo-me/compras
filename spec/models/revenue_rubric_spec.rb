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

  it 'should return full_code' do
    subject.stub(:revenue_category_code => 1)
    subject.stub(:revenue_subcategory_code => 2)
    subject.stub(:revenue_source_code => 3)
    subject.code = 4

    subject.full_code.should eq '1.2.3.4'
  end
end
