require 'spec_helper'

describe PurchaseSolicitationBudgetAllocationItem do
  describe 'validate uniqueness' do
    before { PurchaseSolicitationBudgetAllocationItem.make!(:item) }

    it { should validate_uniqueness_of(:material_id).scoped_to(:purchase_solicitation_budget_allocation_id) }
  end
end
