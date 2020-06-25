class CreateTablePurchaseSolicitationSecretaries < ActiveRecord::Migration
  def change
    create_table :compras_purchase_solicitation_secretaries do |t|
      t.integer :purchase_solicitation_id
      t.integer :secretary_id

      t.timestamps
    end

    add_index :compras_purchase_solicitation_secretaries, :purchase_solicitation_id, name: :cpss_purchase_solicitation_index
    add_index :compras_purchase_solicitation_secretaries, :secretary_id, name: :cpss_secretary_index

    add_foreign_key :compras_purchase_solicitation_secretaries, :compras_purchase_solicitations, column: :purchase_solicitation_id, name: :cpss_purchase_solicitation_fk
    add_foreign_key :compras_purchase_solicitation_secretaries, :compras_secretaries, column: :secretary_id, name: :cpss_secretary_fk
  end

end
