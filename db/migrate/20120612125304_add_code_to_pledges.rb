class AddCodeToPledges < ActiveRecord::Migration
  def change
    add_column :pledges, :code, :integer

    add_index :pledges, [:code, :entity_id, :year], :unique => true
  end
end
