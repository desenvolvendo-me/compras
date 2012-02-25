class CreateSubfunctions < ActiveRecord::Migration
  def change
    create_table :subfunctions do |t|
      t.string :code
      t.string :description
      t.references :function

      t.timestamps
    end

    add_index :subfunctions, :function_id
    add_foreign_key :subfunctions, :functions
  end
end
