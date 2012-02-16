class CreateFunctions < ActiveRecord::Migration
  def change
    create_table :functions do |t|
      t.string :code
      t.references :administractive_act
      t.string :description

      t.timestamps
    end
    add_index :functions, :administractive_act_id
    add_foreign_key :functions, :administractive_acts
  end
end
