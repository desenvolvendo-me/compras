class AddPagamantableToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :pagamentable_id, :integer
    add_column :payments, :pagamentable_type, :string
    add_index  :payments, :pagamentable_id
    add_index  :payments, :pagamentable_type
  end
end
