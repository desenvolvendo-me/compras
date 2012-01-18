class UseCompositedIndexOnPagamentableOnPayments < ActiveRecord::Migration
  def up
    remove_index :payments, :pagamentable_id
    remove_index :payments, :pagamentable_type

    add_index :payments, [:pagamentable_id, :pagamentable_type]
  end

  def down
    remove_index :payments, [:pagamentable_id, :pagamentable_type]

    add_index :payments, :pagamentable_type
    add_index :payments, :pagamentable_id
  end
end
