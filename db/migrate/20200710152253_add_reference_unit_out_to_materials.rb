class AddReferenceUnitOutToMaterials < ActiveRecord::Migration
  def change
    add_column :unico_materials, :output_reference_unit_id, :integer

    add_index :unico_materials, :output_reference_unit_id
    add_foreign_key :unico_materials, :unico_reference_units, column: :output_reference_unit_id
  end
end
