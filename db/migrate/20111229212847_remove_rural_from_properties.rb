class RemoveRuralFromProperties < ActiveRecord::Migration
  def change
    remove_column :properties, :rural
  end
end
