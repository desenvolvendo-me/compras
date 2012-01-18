class CreateCnaes < ActiveRecord::Migration
  def change
    create_table :cnaes do |t|
      t.string :code
      t.string :name
      t.string :section
      t.references :risk_degree

      t.timestamps
    end
    add_index :cnaes, :risk_degree_id
    add_foreign_key :cnaes, :risk_degrees
  end
end
