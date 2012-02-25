class CreateLicitationModalities < ActiveRecord::Migration
  def change
    create_table :licitation_modalities do |t|
      t.references :administractive_act
      t.string :description
      t.decimal :initial_value, :precision => 10, :scale => 2
      t.decimal :final_value, :precision => 10, :scale => 2

      t.timestamps
    end

    add_index :licitation_modalities, :administractive_act_id
    add_foreign_key :licitation_modalities, :administractive_acts
  end
end
