class CreateAdministractiveActsDisseminationSources < ActiveRecord::Migration
  def change
    create_table :administractive_acts_dissemination_sources, :id => false do |t|
      t.integer :administractive_act_id
      t.integer :dissemination_source_id
    end
    add_index :administractive_acts_dissemination_sources, :administractive_act_id, :name => :aads_administractive_act_id
    add_index :administractive_acts_dissemination_sources, :dissemination_source_id, :name => :aads_dissemination_source_id
    add_foreign_key :administractive_acts_dissemination_sources, :administractive_acts, :name => :aads_administractive_act_id_fk
    add_foreign_key :administractive_acts_dissemination_sources, :dissemination_sources, :name => :aads_dissemination_source_id_fk
  end
end
