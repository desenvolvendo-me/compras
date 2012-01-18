class UseFieldTypeEnumerationOnUrbanServices < ActiveRecord::Migration
  def change
    remove_column :urban_services, :field_type_id
    add_column :urban_services, :field_type, :string
  end
end
