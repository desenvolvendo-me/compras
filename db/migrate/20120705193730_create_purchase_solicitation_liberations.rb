class CreatePurchaseSolicitationLiberations < ActiveRecord::Migration
  def change
    create_table :compras_purchase_solicitation_liberations do |t|
      t.text :justification
      t.date :date
      t.integer :purchase_solicitation_id
      t.integer :responsible_id

      t.timestamps
    end

    add_index :compras_purchase_solicitation_liberations, :purchase_solicitation_id, :name => :cpsl_purchase_solicitation_id
    add_index :compras_purchase_solicitation_liberations, :responsible_id, :name => :cpsl_responsible_id
    add_foreign_key :compras_purchase_solicitation_liberations, :compras_purchase_solicitations, :column => :purchase_solicitation_id, :name => :cpsl_purchase_solicitation_id_fk
    add_foreign_key :compras_purchase_solicitation_liberations, :compras_employees, :column => :responsible_id
  end
end
