require 'model_helper'
require 'app/models/revenue_category'
require 'app/models/revenue_subcategory'
require 'app/models/revenue_nature'

describe RevenueCategory do
  it 'should return code as to_s' do
    subject.code = 1
    subject.description = "Receitas correntes"
    subject.to_s.should eq '1 - Receitas correntes'
  end

  it { should validate_presence_of :code }
  it { should validate_presence_of :description }

  it { should have_many(:revenue_subcategories).dependent(:restrict) }
  it { should have_many(:revenue_natures).dependent(:restrict) }
end
