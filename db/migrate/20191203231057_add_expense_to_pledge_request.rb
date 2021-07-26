class AddExpenseToPledgeRequest < ActiveRecord::Migration
  def change
    add_column :compras_pledge_requests,
               :expense_id, :integer
    add_index :compras_pledge_requests, :expense_id
    add_foreign_key :compras_pledge_requests, :compras_expenses,
                    :column => :expense_id
  end
end
