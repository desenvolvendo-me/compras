class CreateSplittings < ActiveRecord::Migration
  def change
    create_table :splittings do |t|
      t.string :name
      t.string :year
      t.references :revenue
      t.string :configuration
      t.integer :plots
      t.boolean :generate_single_plot
      t.integer :interval
      t.date :first_payment

      t.timestamps
    end
    add_index :splittings, :revenue_id
    add_foreign_key :splittings, :revenues
  end
end
