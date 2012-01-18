class CreateTypePublicServices < ActiveRecord::Migration
  def change
    create_table :type_public_services do |t|
      t.string :name
      t.integer :deadline
      t.boolean :automatic_calculation
      t.references :revenue
      t.text :notes

      t.timestamps
    end
    add_index :type_public_services, :revenue_id
    add_foreign_key :type_public_services, :revenues
  end
end
