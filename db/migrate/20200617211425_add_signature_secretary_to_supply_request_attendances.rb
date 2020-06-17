class AddSignatureSecretaryToSupplyRequestAttendances < ActiveRecord::Migration
  def change
    add_column :compras_supply_requests, :signature_secretary_id, :integer
    add_column :compras_supply_requests, :signature_responsible_id, :integer
    add_column :compras_supply_requests, :secretary_signature, :string

    add_index :compras_supply_requests, :signature_secretary_id
    add_index :compras_supply_requests, :signature_responsible_id

    add_foreign_key :compras_supply_requests, :compras_secretaries,
                    column: :signature_secretary_id, name: :compras_suply_request_att_secretary

    add_foreign_key :compras_supply_requests, :compras_employees,
                    column: :signature_responsible_id, name: :compras_suply_request_att_employee
  end
end
