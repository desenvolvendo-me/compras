class CreateActiveDebtRevenues < ActiveRecord::Migration
  def change
    create_table :active_debt_revenues do |t|
      t.references :payment
      t.references :revenue
      t.references :fact_paymentable, :polymorphic => true
      t.decimal :paid_value,                   :precision => 10, :scale => 2
      t.decimal :correction_value,             :precision => 10, :scale => 2
      t.decimal :interest_value,               :precision => 10, :scale => 2
      t.decimal :diff_value,                   :precision => 10, :scale => 2
      t.decimal :discount_value,               :precision => 10, :scale => 2
      t.decimal :fine_discount_value,          :precision => 10, :scale => 2
      t.decimal :correction_discount_value,    :precision => 10, :scale => 2
      t.decimal :tribute_discount_value,       :precision => 10, :scale => 2

      t.timestamps
    end
    add_index :active_debt_revenues, :payment_id
    add_index :active_debt_revenues, :revenue_id
    add_index :active_debt_revenues, :fact_paymentable_id
    add_index :active_debt_revenues, :fact_paymentable_type

    add_foreign_key :active_debt_revenues, :payments
    add_foreign_key :active_debt_revenues, :revenues
  end
end
