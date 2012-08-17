class CreateApplicationCodes < ActiveRecord::Migration
  def change
    create_table :compras_application_codes do |t|
      t.integer :code
      t.boolean :variable, :default => false
      t.string :name
      t.text :specification
      t.string :source

      t.timestamps
    end
  end
end
