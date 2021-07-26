class CreatePurchasingUnits < ActiveRecord::Migration
  def change
    create_table :compras_purchasing_units do |t|
      t.string :name
      t.integer :code
      t.date :starting
      t.string :situation
      t.string :cnpj

      t.timestamps
    end
  end
end