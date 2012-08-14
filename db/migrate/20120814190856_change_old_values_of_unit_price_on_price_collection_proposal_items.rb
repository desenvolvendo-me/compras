class ChangeOldValuesOfUnitPriceOnPriceCollectionProposalItems < ActiveRecord::Migration
  def change
    PriceCollectionProposalItem.where(:unit_price => nil).update_all(:unit_price => 0.0)
  end
end
