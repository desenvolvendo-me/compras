class CreateListPurchaseSolicitations < ActiveRecord::Migration
  def change
    create_table :compras_list_purchase_solicitations do |t|
      t.references :licitation_process
      t.references :purchase_solicitation
      t.string :resource_source
      t.decimal :balance, :precision => 15, :scale => 2
      t.decimal :expected_value, :precision => 15, :scale => 2
      t.decimal :consumed_value, :precision => 15, :scale => 2

      t.timestamps
    end

    add_index :compras_list_purchase_solicitations, :licitation_process_id,
              name: :clps_licitation_process_fk
    add_foreign_key :compras_list_purchase_solicitations,
                    :compras_licitation_processes,
                    column: :licitation_process_id,
                    name: :clps_licitation_process_fk

    add_index :compras_list_purchase_solicitations,
              :purchase_solicitation_id,
              name: :clps_purchase_solicitation_id
    add_foreign_key :compras_list_purchase_solicitations,
                    :compras_purchase_solicitations,
                    column: :purchase_solicitation_id,
                    name: :clps_purchase_solicitation_fk

  end
end
