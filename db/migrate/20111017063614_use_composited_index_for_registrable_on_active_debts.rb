class UseCompositedIndexForRegistrableOnActiveDebts < ActiveRecord::Migration
  def up
    remove_index :active_debts, :registrable_id

    add_index :active_debts, [:registrable_id, :registrable_type]
  end

  def down
    remove_index :active_debts, [:registrable_id, :registrable_type]

    add_index :active_debts, :registrable_id
  end
end
