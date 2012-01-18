class RemoveChargeBackAccountedIdFromPayments < ActiveRecord::Migration
  def change
    remove_column :payments, :charge_back_accounted_id
  end
end
