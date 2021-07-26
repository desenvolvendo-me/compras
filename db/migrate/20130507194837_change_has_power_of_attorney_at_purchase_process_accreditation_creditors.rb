class ChangeHasPowerOfAttorneyAtPurchaseProcessAccreditationCreditors < ActiveRecord::Migration
  def change
    change_column :compras_purchase_process_accreditation_creditors, :has_power_of_attorney,
                  :boolean, null: false, default: false
  end
end
