class AddLicitationComissionIdToTradings < ActiveRecord::Migration
  def change
    add_column :compras_tradings, :licitation_commission_id, :integer

    add_index :compras_tradings, :licitation_commission_id

    add_foreign_key :compras_tradings, :compras_licitation_commissions,
                    :column => :licitation_commission_id
  end
end
