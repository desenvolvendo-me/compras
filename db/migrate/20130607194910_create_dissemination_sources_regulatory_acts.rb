class CreateDisseminationSourcesRegulatoryActs < ActiveRecord::Migration
  def change
    create_table :compras_dissemination_sources_compras_regulatory_acts, :id => false, :force => true do |t|
      t.integer :regulatory_act_id, :null => false
      t.integer :dissemination_source_id, :null => false
    end

    add_index :compras_dissemination_sources_compras_regulatory_acts,
              :dissemination_source_id,
              :name => :compras_cdsacra_dissemination_source_id

    add_index :compras_dissemination_sources_compras_regulatory_acts,
              :regulatory_act_id,
              :name => :comrpas_cdscra_regulatory_act_id

    add_foreign_key :compras_dissemination_sources_compras_regulatory_acts,
                    :compras_dissemination_sources,
                    :name => :compras_cdsacra_dissemination_source_id_fk,
                    :column => :dissemination_source_id

    add_foreign_key :compras_dissemination_sources_compras_regulatory_acts,
                    :compras_regulatory_acts,
                    :name => :compras_cdsacra_administractive_act_id_fk,
                    :column => :regulatory_act_id
  end
end
