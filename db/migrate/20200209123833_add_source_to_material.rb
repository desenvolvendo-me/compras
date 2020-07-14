class AddSourceToMaterial < ActiveRecord::Migration
  def change
    add_column :compras_materials, :origin_source, :string
  end
end
