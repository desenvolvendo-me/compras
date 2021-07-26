class CreateAgreementOccurrences < ActiveRecord::Migration
  def change
    create_table :compras_agreement_occurrences do |t|
      t.date :date
      t.string :kind
      t.string :description
      t.references :agreement

      t.timestamps
    end

    add_index :compras_agreement_occurrences, :agreement_id

    add_foreign_key :compras_agreement_occurrences, :compras_agreements,
                    :column => :agreement_id
  end
end
