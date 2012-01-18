class CreateParcelAgreements < ActiveRecord::Migration
  def change
    create_table :parcel_agreements do |t|
      t.references :agreement
      t.date :due_date
      t.integer :parcel_number
      t.string :status
      t.string :cancel_motive
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
    add_index :parcel_agreements, :agreement_id
    add_foreign_key :parcel_agreements, :agreements
  end
end
