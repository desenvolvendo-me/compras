class CreateEconomicClassificationOfExpenditures < ActiveRecord::Migration
  def change
    create_table :economic_classification_of_expenditures do |t|
      t.integer :entity_id
      t.integer :administractive_act_id
      t.string :economic_classification_of_expenditure
      t.string :kind
      t.string :description
      t.text :docket

      t.timestamps
    end

    add_index :economic_classification_of_expenditures, :entity_id
    add_index :economic_classification_of_expenditures, :administractive_act_id, :name => 'index_ecoe_on_administractive_act_id'

    add_foreign_key :economic_classification_of_expenditures, :entities
    add_foreign_key :economic_classification_of_expenditures, :administractive_acts, :name => 'ecoe_administractive_act_fk'
  end
end
