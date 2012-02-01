class ChangeServiceTypeNameType < ActiveRecord::Migration
  def up
    change_column :service_types, :name, :string
  end

  def down
    change_column :service_types, :name, :text
  end
end
