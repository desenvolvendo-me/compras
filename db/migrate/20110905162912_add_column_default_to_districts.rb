class AddColumnDefaultToDistricts < ActiveRecord::Migration
  def change
    add_column :districts, :default, :boolean, :default => false
  end
end
