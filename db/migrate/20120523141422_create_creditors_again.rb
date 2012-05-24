class CreateCreditorsAgain < ActiveRecord::Migration
  def change
    create_table :creditors do |t|
      t.references :person
      t.references :occupation_classification
      t.boolean :municipal_public_administration, :default => false
      t.boolean :autonomous,                      :default => false
      t.string :social_identification_number
      t.date :social_identification_number_date
      t.references :company_size
      t.boolean :choose_simple,                   :default => false
      t.references :main_cnae

      t.timestamps
    end

    add_index :creditors, :person_id
    add_index :creditors, :occupation_classification_id
    add_index :creditors, :company_size_id
    add_index :creditors, :main_cnae_id
    add_foreign_key :creditors, :people
    add_foreign_key :creditors, :occupation_classifications
    add_foreign_key :creditors, :company_sizes
    add_foreign_key :creditors, :cnaes, :column => :main_cnae_id
  end
end
