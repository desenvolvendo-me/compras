class RemoveCondominiumIdToAdressess < ActiveRecord::Migration
  def up
    remove_column :addresses, :condominium_id
  end

  def down
    add_column :addresses, :condominium_id, :integer
  end
end
