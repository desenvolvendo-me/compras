class UseCompositedIndexForFactPaymentableOnActiveDebtsRevenues < ActiveRecord::Migration
  def up
    remove_index :active_debt_revenues, :fact_paymentable_id
    remove_index :active_debt_revenues, :fact_paymentable_type

    add_index :active_debt_revenues, [:fact_paymentable_id, :fact_paymentable_type], :name => :index_active_debt_revenues_on_fact_paymentable
  end

  def down
    remove_index :active_debt_revenues, :name => :index_active_debt_revenues_on_fact_paymentable

    add_index :active_debt_revenues, :fact_paymentable_id
    add_index :active_debt_revenues, :fact_paymentable_type
  end
end
