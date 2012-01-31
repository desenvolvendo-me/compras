class CreateConfigurationOrganograms < ActiveRecord::Migration
  def change
    create_table :configuration_organograms do |t|
      t.integer :entity_id
      t.integer :administractive_act_id
      t.string :name

      t.timestamps
    end

    add_index :configuration_organograms, :administractive_act_id
    add_foreign_key :configuration_organograms, :administractive_acts

    add_index :configuration_organograms, :entity_id
    add_foreign_key :configuration_organograms, :entities
  end
end
