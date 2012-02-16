# encoding: utf-8
require 'model_helper'
require 'app/models/budget_allocation_type'

describe BudgetAllocationType do
  it "should return the describe as to_s method" do
    subject.description = "Dotação Administrativa"

    subject.to_s.should eq "Dotação Administrativa"
  end

  it { should validate_presence_of :description }
end
