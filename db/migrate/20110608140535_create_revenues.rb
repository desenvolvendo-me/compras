class CreateRevenues < ActiveRecord::Migration
  def change
    create_table :revenues do |t|
      t.string :name
      t.string :acronym
      t.references :incidence_revenue
      t.references :currency
      t.text :legislation
      t.references :type_revenue
      t.string :budget_code
      t.boolean :active_debt

      t.timestamps
    end
    add_index :revenues, :incidence_revenue_id
    add_index :revenues, :currency_id
    add_index :revenues, :type_revenue_id
    add_foreign_key :revenues, :incidence_revenues
    add_foreign_key :revenues, :currencies
    add_foreign_key :revenues, :type_revenues
  end
end
