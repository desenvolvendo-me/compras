class AddModalityToPledges < ActiveRecord::Migration
  def change
    add_column :compras_pledges, :modality, :string
  end
end
