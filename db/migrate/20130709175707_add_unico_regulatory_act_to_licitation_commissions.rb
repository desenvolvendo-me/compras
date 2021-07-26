class AddUnicoRegulatoryActToLicitationCommissions < ActiveRecord::Migration
  def change
    add_column :compras_licitation_commissions, :regulatory_act_id, :integer

    add_index :compras_licitation_commissions, :regulatory_act_id
    add_foreign_key :compras_licitation_commissions, :unico_regulatory_acts, column: :regulatory_act_id
  end
end
