class CreateExtendedCompanySizes < ActiveRecord::Migration
  def change
    create_table :compras_extended_company_sizes do |t|
      t.references :company_size
      t.boolean :benefited

      t.timestamps
    end

    add_index :compras_extended_company_sizes, :company_size_id
    add_foreign_key :compras_extended_company_sizes, :unico_company_sizes, :column => :company_size_id
  end
end
