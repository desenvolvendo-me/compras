require 'model_helper'
require 'app/models/purchase_solicitation_item_group_material_purchase_solicitation'


describe PurchaseSolicitationItemGroupMaterialPurchaseSolicitation do
  it { should belong_to(:purchase_solicitation_item_group_material) }
  it { should belong_to(:purchase_solicitation) }

  it { should validate_presence_of :purchase_solicitation }
  it { should validate_presence_of :purchase_solicitation_item_group_material }
end
