class CreateInfractionsRevenues < ActiveRecord::Migration
  def change
    create_table :infractions_revenues, :id => false do |t|
      t.integer :infraction_id
      t.integer :revenue_id
    end
    add_index :infractions_revenues, :infraction_id
    add_index :infractions_revenues, :revenue_id
    add_foreign_key :infractions_revenues, :infractions
    add_foreign_key :infractions_revenues, :revenues
  end
end
