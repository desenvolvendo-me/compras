class CreateComprasPurchaseProcessAccreditationCreditors < ActiveRecord::Migration
  def change
    create_table :compras_purchase_process_accreditation_creditors do |t|
      t.integer  :purchase_process_accreditation_id
      t.integer  :creditor_id
      t.integer  :company_size_id
      t.integer  :creditor_representative_id
      t.string   :kind
      t.boolean  :has_power_of_attorney
      t.timestamps
    end

    add_index :compras_purchase_process_accreditation_creditors, :purchase_process_accreditation_id,
              :name => :cppa_purchase_process_accreditation_idx
    add_index :compras_purchase_process_accreditation_creditors, :creditor_id,
              :name => :cppa_creditor_idx
    add_index :compras_purchase_process_accreditation_creditors, :company_size_id,
              :name => :cppa_company_size_idx
    add_index :compras_purchase_process_accreditation_creditors, :creditor_representative_id,
              :name => :cppa_creditor_representatice_idx

    add_foreign_key :compras_purchase_process_accreditation_creditors, :compras_purchase_process_accreditations,
                    :column => :purchase_process_accreditation_id, :name => :cppa_purchase_process_accreditation_fk
    add_foreign_key :compras_purchase_process_accreditation_creditors, :compras_creditors,
                    :column => :creditor_id, :name => :cppa_creditor_fk
    add_foreign_key :compras_purchase_process_accreditation_creditors, :unico_company_sizes,
                    :column => :company_size_id, :name => :cppa_company_size_fk
    #add_foreign_key :compras_purchase_process_accreditation_creditors, :compras_creditor_representatives,
    #               :column => :creditor_representative_id, :name => :cppa_creditor_representatice_fk
  end
end
