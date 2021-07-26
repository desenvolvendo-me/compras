class CreateTceCapabilityAgreements < ActiveRecord::Migration
  def change
    create_table "compras_tce_capability_agreements" do |t|
      t.integer "tce_specification_capability_id"
      t.integer "agreement_id"
    end

    add_index :compras_tce_capability_agreements, :agreement_id
    add_index :compras_tce_capability_agreements, :tce_specification_capability_id,
              :name => :index_compras_tca_on_tce_specification_capability_id

    add_foreign_key :compras_tce_capability_agreements, :compras_agreements,
                    :column => :agreement_id
    add_foreign_key :compras_tce_capability_agreements, :compras_tce_specification_capabilities,
                    :column => :tce_specification_capability_id,
                    :name => :tce_specification_capability_fk
  end
end
