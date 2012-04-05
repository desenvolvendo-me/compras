class CreateRevenueRubrics < ActiveRecord::Migration
  def change
    create_table :revenue_rubrics do |t|
      t.string :code
      t.string :description
      t.integer :revenue_source_id

      t.timestamps
    end

    add_index :revenue_rubrics, :revenue_source_id

    add_foreign_key :revenue_rubrics, :revenue_sources
  end
end
