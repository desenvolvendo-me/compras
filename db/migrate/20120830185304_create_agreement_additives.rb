class CreateAgreementAdditives < ActiveRecord::Migration
  def change
    create_table :compras_agreement_additives do |t|
      t.string :kind
      t.references :agreement
      t.references :regulatory_act
      t.decimal :value, :precision => 10, :scale => 2
      t.string :description

      t.timestamps
    end

    add_index :compras_agreement_additives, :agreement_id
    add_index :compras_agreement_additives, :regulatory_act_id

    add_foreign_key :compras_agreement_additives, :compras_agreements,
                    :column => :agreement_id
    add_foreign_key :compras_agreement_additives, :compras_regulatory_acts,
                    :column => :regulatory_act_id
  end
end
