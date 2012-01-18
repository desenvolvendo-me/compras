class CreateFiscalProgrammings < ActiveRecord::Migration
  def change
    create_table :fiscal_programmings do |t|
      t.integer :year
      t.date :started_at
      t.date :finished_at
      t.date :scheduled_date
      t.string :fiscal_nature_incidence
      t.string :guideline
      t.text :observation

      t.timestamps
    end
  end
end
