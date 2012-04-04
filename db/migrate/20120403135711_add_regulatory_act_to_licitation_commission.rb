class AddRegulatoryActToLicitationCommission < ActiveRecord::Migration
  def change
    add_column :licitation_commissions, :regulatory_act_id, :integer

    add_index :licitation_commissions, :regulatory_act_id

    add_foreign_key :licitation_commissions, :regulatory_acts
  end
end