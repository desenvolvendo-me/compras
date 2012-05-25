class ContractStartDateToCreditors < ActiveRecord::Migration
  def change
    add_column :creditors, :contract_start_date, :date
  end
end
