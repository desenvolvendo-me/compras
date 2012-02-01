# encoding: utf-8
require 'model_helper'
require 'app/models/budget_allocation'
require 'app/models/purchase_solicitation'

describe BudgetAllocation do
  it 'should return name as to_s method' do
    subject.name = "Dotação"

    subject.to_s.should eq("Dotação")
  end

  it { should have_many :purchase_solicitations }
  it { should validate_presence_of :name }
end
