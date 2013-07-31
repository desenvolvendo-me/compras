require 'spec_helper'

describe PurchaseSolicitationItem do
  describe 'validate uniqueness' do
    before { PurchaseSolicitationItem.make!(:item) }

    it { should validate_uniqueness_of(:material_id).scoped_to(:purchase_solicitation_id) }
  end
end
