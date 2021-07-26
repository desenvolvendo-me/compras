class AddCnaeToCompany < ActiveRecord::Migration
  def change
    #add_reference :unico_companies, :main_cnae, index: true

    add_foreign_key :unico_companies, :unico_cnaes,
                    column: :main_cnae_id

    add_index :unico_companies, :main_cnae_id
  end
end
