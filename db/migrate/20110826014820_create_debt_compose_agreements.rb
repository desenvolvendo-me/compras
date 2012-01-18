class CreateDebtComposeAgreements < ActiveRecord::Migration
  def change
    create_table :debt_compose_agreements do |t|
      t.references :agreement
      t.references :revenue
      t.decimal :tribute_value, :precision => 10, :scale => 2
      t.decimal :correction_value, :precision => 10, :scale => 2
      t.decimal :interest_value, :precision => 10, :scale => 2
      t.decimal :fine_value, :precision => 10, :scale => 2
      t.decimal :real_tribute_value, :precision => 10, :scale => 2
      t.decimal :discount_tribute_value, :precision => 10, :scale => 2
      t.decimal :discount_correction_value, :precision => 10, :scale => 2
      t.decimal :discount_interest_value, :precision => 10, :scale => 2
      t.decimal :discount_fine_value, :precision => 10, :scale => 2

      t.timestamps
    end
    add_index :debt_compose_agreements, :agreement_id
    add_index :debt_compose_agreements, :revenue_id
    add_foreign_key :debt_compose_agreements, :agreements
    add_foreign_key :debt_compose_agreements, :revenues
  end
end
