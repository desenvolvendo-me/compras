class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.string :name
      t.string :description
      t.string :format
      t.references :setting, :polymorphic => true

      t.timestamps
    end
    add_index :fields, :setting_id
  end
end
