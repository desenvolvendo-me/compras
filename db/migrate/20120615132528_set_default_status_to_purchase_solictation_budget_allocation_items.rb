class SetDefaultStatusToPurchaseSolictationBudgetAllocationItems < ActiveRecord::Migration
  def change
    PurchaseSolicitationBudgetAllocationItem.update_all :status => PurchaseSolicitationBudgetAllocationItemStatus::PENDING
  end
end
