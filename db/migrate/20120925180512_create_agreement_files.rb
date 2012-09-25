class CreateAgreementFiles < ActiveRecord::Migration
  def change
    create_table :compras_agreement_files do |t|
      t.references :agreement
      t.string :file
      t.string :name

      t.timestamps
    end

    add_index :compras_agreement_files, :agreement_id

    add_foreign_key :compras_agreement_files, :compras_agreements,
                    :column => :agreement_id
  end
end
