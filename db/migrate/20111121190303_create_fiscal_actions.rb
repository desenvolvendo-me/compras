class CreateFiscalActions < ActiveRecord::Migration
  def change
    create_table :fiscal_actions do |t|
      t.integer :year
      t.references :economic_registration
      t.references :fiscal_programming
      t.string :guideline
      t.string :status
      t.date :started_at
      t.date :finished_at
      t.date :started_date
      t.date :finished_date
      t.integer :estimated_date
      t.text :tax_advice

      t.timestamps
    end
    add_index :fiscal_actions, :economic_registration_id
    add_index :fiscal_actions, :fiscal_programming_id
  end
end
