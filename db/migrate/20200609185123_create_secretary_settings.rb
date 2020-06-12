class CreateSecretarySettings < ActiveRecord::Migration
  def change
    create_table :compras_secretary_settings do |t|
      t.references :secretary,           index: true
      t.references :employee,            index: true
      t.string     :digital_signature
      t.string     :signature
      t.decimal    :authorization_value, precision: 15, scale: 2
      t.timestamps
    end

    add_foreign_key :compras_secretary_settings,
                    :compras_secretaries,
                    column: :secretary_id,
                    name: :css_secretary_id

    add_foreign_key :compras_secretary_settings,
                    :compras_employees,
                    column: :employee_id,
                    name: :css_employee_id
  end
end
