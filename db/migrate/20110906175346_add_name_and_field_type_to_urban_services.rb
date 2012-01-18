class AddNameAndFieldTypeToUrbanServices < ActiveRecord::Migration
  def change
    add_column :urban_services, :name, :string
    add_column :urban_services, :field_type_id, :integer
    add_index :urban_services, :field_type_id
    add_foreign_key :urban_services, :field_types
  end
end
