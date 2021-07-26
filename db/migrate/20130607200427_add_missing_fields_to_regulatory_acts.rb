class AddMissingFieldsToRegulatoryActs < ActiveRecord::Migration
  def change
    add_column :compras_regulatory_acts, :additional_percent, :decimal, :precision => 10, :scale => 2
    add_column :compras_regulatory_acts, :article_number, :string
    add_column :compras_regulatory_acts, :article_description, :text
    add_column :compras_regulatory_acts, :authorized_value, :decimal, :precision => 10, :scale => 2
    add_column :compras_regulatory_acts, :regulatory_act_type, :string
  end
end
