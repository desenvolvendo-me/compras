class AddUnicoRegulatoryActToAggrements < ActiveRecord::Migration
  def change
    add_column :compras_agreements, :regulatory_act_id, :integer

    add_index :compras_agreements, :regulatory_act_id
    add_foreign_key :compras_agreements, :unico_regulatory_acts, column: :regulatory_act_id
  end
end
