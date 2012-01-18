class RenamePagamentableToPayable < ActiveRecord::Migration
  def up
    remove_index :payments, [:pagamentable_id, :pagamentable_type]

    rename_column :payments, :pagamentable_id, :payable_id
    rename_column :payments, :pagamentable_type, :payable_type

    add_index :payments, [:payable_id, :payable_type]
  end

  def down
    remove_index :payments, [:payable_id, :payable_type]

    rename_column :payments, :payable_id, :payment_id
    rename_column :payments, :payable_type, :payment_type

    add_index :payments, [:pagamentable_id, :pagamentable_type]
  end
end
