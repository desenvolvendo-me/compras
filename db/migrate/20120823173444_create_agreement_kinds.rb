class CreateAgreementKinds < ActiveRecord::Migration
  def change
    create_table :compras_agreement_kinds do |t|
      t.string :description
      t.integer :tce_code

      t.timestamps
    end
  end
end
