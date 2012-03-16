class AddCondominiumIdToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :condominium_id, :integer
  end
end
