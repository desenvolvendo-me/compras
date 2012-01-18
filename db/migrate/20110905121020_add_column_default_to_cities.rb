class AddColumnDefaultToCities < ActiveRecord::Migration
  def change
    add_column :cities, :default, :boolean, :default => false
  end
end
