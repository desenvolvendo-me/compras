# encoding: utf-8
require 'model_helper'
require 'app/models/purchase_solicitation_budget_allocation'

describe PurchaseSolicitationBudgetAllocation do
  describe 'default values' do
    it 'uses false as default for blocked' do
      expect(subject.blocked).to be false
    end
  end

  it { should delegate(:services?).to(:purchase_solicitation).allowing_nil(true) }
  it { should delegate(:expense_nature).to(:budget_allocation).allowing_nil(true).prefix(true) }
  it { should delegate(:amount).to(:budget_allocation).allowing_nil(true).prefix(true) }

  it { should validate_presence_of :budget_allocation }
  it { should belong_to :purchase_solicitation }
  it { should belong_to :budget_allocation }

  it "should have false as the default value of blocked" do
    expect(subject.blocked).to eq false
  end
end
