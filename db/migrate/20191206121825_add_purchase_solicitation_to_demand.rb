class AddPurchaseSolicitationToDemand < ActiveRecord::Migration
  def change
    add_column :compras_demands,
               :purchase_solicitation_id, :integer
    add_index :compras_demands, :purchase_solicitation_id
    add_foreign_key :compras_demands, :compras_purchase_solicitations,
                    :column => :purchase_solicitation_id
  end
end