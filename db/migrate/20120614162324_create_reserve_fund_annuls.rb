class CreateReserveFundAnnuls < ActiveRecord::Migration
  def change
    create_table :compras_reserve_fund_annuls do |t|
      t.integer :reserve_fund_id
      t.integer :employee_id
      t.date :date

      t.timestamps
    end

    add_index :compras_reserve_fund_annuls, :reserve_fund_id
    add_index :compras_reserve_fund_annuls, :employee_id

    add_foreign_key :compras_reserve_fund_annuls, :compras_reserve_funds, :column => :reserve_fund_id
    add_foreign_key :compras_reserve_fund_annuls, :compras_employees, :column => :employee_id
  end
end
