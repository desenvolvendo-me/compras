require 'model_helper'
require 'app/models/revenue_source'
require 'app/models/revenue_rubric'
require 'app/models/revenue_nature'

describe RevenueSource do
  it 'should return code as to_s' do
    subject.code = 1
    subject.description = 'Imposto'
    subject.to_s.should eq '1 - Imposto'
  end

  it { should validate_presence_of :code }
  it { should validate_presence_of :description }
  it { should validate_presence_of :revenue_subcategory }

  it { should belong_to :revenue_subcategory }
  it { should have_many(:revenue_rubrics).dependent(:restrict) }
  it { should have_many(:revenue_natures).dependent(:restrict) }
end
