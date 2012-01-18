class RemoveFieldTypeFromUrbanServices < ActiveRecord::Migration
  def up
    remove_column :urban_services, :field_type
  end

  def down
    add_column :urban_services, :field_type, :string
  end
end
