class CreateChargeBackAccounteds < ActiveRecord::Migration
  def change
    create_table :charge_back_accounteds do |t|
      t.string :name
      t.string :acronym

      t.timestamps
    end
  end
end
