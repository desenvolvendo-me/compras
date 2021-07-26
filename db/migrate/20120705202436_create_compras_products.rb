class CreateComprasProducts < ActiveRecord::Migration
  def change
    create_table :compras_products do |t|
      t.string :specification
      t.text   :observation

      t.timestamp
    end
  end
end
