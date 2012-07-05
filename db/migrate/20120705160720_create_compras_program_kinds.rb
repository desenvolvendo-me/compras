class CreateComprasProgramKinds < ActiveRecord::Migration
  def change
    create_table :compras_program_kinds do |t|
      t.string :specification

      t.timestamp
    end
  end
end
