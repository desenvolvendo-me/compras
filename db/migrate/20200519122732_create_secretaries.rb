class CreateSecretaries < ActiveRecord::Migration
  def change
    create_table :compras_secretaries do |t|
      t.string :name
      t.references :employee

      t.timestamps
    end

    add_index :compras_secretaries, :employee_id
    add_foreign_key :compras_secretaries,:compras_employees,
                    :column => :employee_id
  end
end
