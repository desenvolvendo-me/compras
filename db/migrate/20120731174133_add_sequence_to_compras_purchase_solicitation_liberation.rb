class AddSequenceToComprasPurchaseSolicitationLiberation < ActiveRecord::Migration
  def change
    add_column :compras_purchase_solicitation_liberations, :sequence, :integer
  end
end
