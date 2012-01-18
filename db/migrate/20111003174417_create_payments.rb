class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :parcel_to_be_paid
      t.references :write_off_motive
      t.references :diff_value_motive
      t.references :user
      t.references :write_off_type_payment
      t.references :payment_type
      t.references :payment_state
      t.references :payment_accounted
      t.references :charge_back_accounted
      t.references :prefecture

      t.decimal :paid_value,                 :precision => 10, :scale => 2
      t.decimal :interest_value,             :precision => 10, :scale => 2
      t.decimal :fine_value,                 :precision => 10, :scale => 2
      t.decimal :correction_value,           :precision => 10, :scale => 2
      t.decimal :write_off_diff_value,       :precision => 10, :scale => 2
      t.decimal :interest_discount_value,    :precision => 10, :scale => 2
      t.decimal :fine_discount_value,        :precision => 10, :scale => 2
      t.decimal :correction_discount_value,  :precision => 10, :scale => 2
      t.decimal :tribute_discount_value,     :precision => 10, :scale => 2
      t.decimal :tribute,                    :precision => 10, :scale => 2
      t.decimal :correction,                 :precision => 10, :scale => 2
      t.decimal :fine,                       :precision => 10, :scale => 2
      t.decimal :interest,                   :precision => 10, :scale => 2

      t.date :payment_date
      t.date :write_back_date
      t.datetime :movimentation_hour
      t.integer :payment_lot
      t.integer :year
      t.string :barcode
      t.boolean :accounted_lot, :default => false

      t.timestamps
    end
    add_index :payments, :write_off_motive_id
    add_index :payments, :diff_value_motive_id
    add_index :payments, :write_off_type_payment_id
    add_index :payments, :payment_type_id
    add_index :payments, :payment_state_id
    add_index :payments, :payment_accounted_id
    add_index :payments, :charge_back_accounted_id
    add_index :payments, :prefecture_id
    add_index :payments, :user_id

    add_foreign_key :payments, :motives, :column => :write_off_motive_id
    add_foreign_key :payments, :motives, :column => :diff_value_motive_id
    add_foreign_key :payments, :write_off_type_payments
    add_foreign_key :payments, :payment_types
    add_foreign_key :payments, :payment_states
    add_foreign_key :payments, :payment_accounteds
    add_foreign_key :payments, :charge_back_accounteds
    add_foreign_key :payments, :prefectures
    add_foreign_key :payments, :users
  end
end
