class SetDefaultStatusToPurchaseSolictationBudgetAllocationItems < ActiveRecord::Migration
  def change
    PurchaseSolicitationBudgetAllocationItem.find_each do |item|
      item.update_attribute :status, PurchaseSolicitationBudgetAllocationItemStatus::PENDING
    end
  end
end
