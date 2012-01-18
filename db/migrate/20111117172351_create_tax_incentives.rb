class CreateTaxIncentives < ActiveRecord::Migration
  def change
    create_table :tax_incentives do |t|
      t.string :name
      t.string :number_of_law
      t.integer :validity
      t.string :validity_type
      t.date :started_at
      t.date :finished_at
      t.references :exemption
      t.text :legal_basis

      t.timestamps
    end

    add_index :tax_incentives, :exemption_id
    add_foreign_key :tax_incentives, :exemptions
  end
end
