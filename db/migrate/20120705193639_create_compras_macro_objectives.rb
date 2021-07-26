class CreateComprasMacroObjectives < ActiveRecord::Migration
  def change
    create_table :compras_macro_objectives do |t|
      t.string :specification
      t.text :observation

      t.timestamp
    end
  end
end
