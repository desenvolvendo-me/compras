class CreateOrganograms < ActiveRecord::Migration
  def change
    create_table :organograms do |t|
      t.integer :configuration_organogram_id
      t.string :organogram
      t.string :tce_code
      t.string :name
      t.string :acronym
      t.integer :type_of_administractive_act_id
      t.string :performance_field

      t.timestamps
    end

    add_index :organograms, :configuration_organogram_id
    add_foreign_key :organograms, :configuration_organograms

    add_index :organograms, :type_of_administractive_act_id
    add_foreign_key :organograms, :type_of_administractive_acts
  end
end
