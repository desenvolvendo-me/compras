class CreateAgreements < ActiveRecord::Migration
  def change
    create_table :compras_agreements do |t|
      t.integer :code
      t.integer :number
      t.integer :year
      t.string :category
      t.references :agreement_kind
      t.decimal :value, :precision => 10, :scale => 2
      t.decimal :counterpart_value, :precision => 10, :scale => 2
      t.integer :parcels_number
      t.string :description
      t.integer :process_number
      t.integer :process_year
      t.date :process_date
      t.references :regulatory_act
      t.string :agreement_file

      t.timestamps
    end

    add_index :compras_agreements, :agreement_kind_id
    add_index :compras_agreements, :regulatory_act_id

    add_foreign_key :compras_agreements, :compras_agreement_kinds,
                    :column => :agreement_kind_id
    add_foreign_key :compras_agreements, :compras_regulatory_acts,
                    :column => :regulatory_act_id
  end
end
