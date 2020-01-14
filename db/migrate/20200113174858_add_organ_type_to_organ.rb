class AddOrganTypeToOrgan < ActiveRecord::Migration
  def change
    add_column :compras_organs, :organ_type, :string
  end
end
