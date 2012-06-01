class CreditorSecondaryCnaes < ActiveRecord::Migration
  def change
    create_table :creditor_secondary_cnaes do |t|
      t.integer :creditor_id
      t.integer :cnae_id
    end

    add_index :creditor_secondary_cnaes, :creditor_id
    add_index :creditor_secondary_cnaes, :cnae_id

    add_foreign_key :creditor_secondary_cnaes, :creditors
    add_foreign_key :creditor_secondary_cnaes, :cnaes
  end
end
