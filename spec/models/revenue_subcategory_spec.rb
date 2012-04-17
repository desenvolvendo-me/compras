# encoding: utf-8
require 'model_helper'
require 'app/models/revenue_subcategory'
require 'app/models/revenue_source'

describe RevenueSubcategory do
  it 'should return code as to_s' do
    subject.code = 1
    subject.description = "Receita tributária"
    subject.to_s.should eq '1 - Receita tributária'
  end

  it { should validate_presence_of :code }
  it { should validate_presence_of :description }
  it { should validate_presence_of :revenue_category }

  it { should belong_to :revenue_category }
  it { should have_many(:revenue_sources).dependent(:restrict) }
end
