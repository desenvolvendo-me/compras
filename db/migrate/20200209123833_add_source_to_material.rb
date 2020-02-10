class AddSourceToMaterial < ActiveRecord::Migration
  def change
    add_column :unico_materials, :origin_source, :string
  end
end
