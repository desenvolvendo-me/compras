class CreateCheckingAccountStructures < ActiveRecord::Migration
  def change
    create_table :compras_checking_account_structures do |t|
      t.references :checking_account_of_fiscal_account
      t.string :name
      t.string :tag
      t.string :description
      t.string :fill
      t.string :reference
      t.references :checking_account_structure_information

      t.timestamps
    end

    add_index :compras_checking_account_structures, :checking_account_of_fiscal_account_id,
              :name => :index_cas_on_checking_account_of_fiscal_account_id
    add_index :compras_checking_account_structures, :checking_account_structure_information_id,
              :name => :index_cas_on_checking_account_structure_information_id

    add_foreign_key :compras_checking_account_structures, :compras_checking_account_of_fiscal_accounts,
                    :column => :checking_account_of_fiscal_account_id,
                    :name => :compras_cas_checking_account_of_fiscal_account_id_fk
    add_foreign_key :compras_checking_account_structures, :compras_checking_account_structure_informations,
                    :column => :checking_account_structure_information_id,
                    :name => :compras_cas_checking_account_structure_id_fk
  end
end
