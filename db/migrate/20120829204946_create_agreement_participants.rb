class CreateAgreementParticipants < ActiveRecord::Migration
  def change
    create_table :compras_agreement_participants do |t|
      t.string :kind
      t.string :governmental_sphere
      t.decimal :value, :precision => 10, :scale => 2
      t.references :creditor
      t.references :agreement

      t.timestamps
    end

    add_index :compras_agreement_participants, :agreement_id
    add_index :compras_agreement_participants, :creditor_id

    add_foreign_key :compras_agreement_participants, :compras_agreements,
                    :column => :agreement_id
    add_foreign_key :compras_agreement_participants, :compras_creditors,
                    :column => :creditor_id
  end
end
