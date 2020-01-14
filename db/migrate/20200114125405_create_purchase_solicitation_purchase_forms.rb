class CreatePurchaseSolicitationPurchaseForms < ActiveRecord::Migration
  def change
    create_table :compras_purchase_solicitation_purchase_forms do |t|
      t.references :purchase_solicitation
      t.references :purchase_form

      t.timestamps
    end
  end
end
