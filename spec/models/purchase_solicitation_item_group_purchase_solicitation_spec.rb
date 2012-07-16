require 'model_helper'
require 'app/models/purchase_solicitation_item_group_purchase_solicitation'


describe PurchaseSolicitationItemGroupPurchaseSolicitation do
  it { should belong_to(:purchase_solicitation_item_group) }
  it { should belong_to(:purchase_solicitation) }

  it { should validate_presence_of :purchase_solicitation }
  it { should validate_presence_of :purchase_solicitation_item_group }
end
