class AddActiveToSecretarySettings < ActiveRecord::Migration
  def change
    add_column :compras_secretary_settings, :start_date, :boolean
    add_column :compras_secretary_settings, :end_date, :boolean
    add_column :compras_secretary_settings, :concierge, :boolean
    add_column :compras_secretary_settings, :active, :boolean

    add_index :compras_secretary_settings, :secretary_id
    add_index :compras_secretary_settings, :employee_id

    add_foreign_key :compras_secretary_settings, :compras_secretaries,
                    :column => :secretary_id

    add_foreign_key :compras_secretary_settings, :compras_employees,
                    :column => :employee_id
  end
end
