class ChangeRegulatoryActTypeOnRegulatoryActs < ActiveRecord::Migration
  def change
    change_column :compras_regulatory_acts, :regulatory_act_type, :integer
  end
end
