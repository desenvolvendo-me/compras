class DropTableChargeBackAccounteds < ActiveRecord::Migration
  def change
    drop_table :charge_back_accounteds
  end
end
