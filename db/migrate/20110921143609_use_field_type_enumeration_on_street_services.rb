class UseFieldTypeEnumerationOnStreetServices < ActiveRecord::Migration
  def change
    remove_column :street_services, :field_type_id
    add_column :street_services, :field_type, :string
  end
end
