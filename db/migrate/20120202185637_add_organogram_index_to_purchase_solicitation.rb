class AddOrganogramIndexToPurchaseSolicitation < ActiveRecord::Migration
  def change
    add_index :purchase_solicitations, :organogram_id
  end
end
