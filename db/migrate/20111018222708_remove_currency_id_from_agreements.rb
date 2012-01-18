class RemoveCurrencyIdFromAgreements < ActiveRecord::Migration
  def change
    remove_column :agreements, :currency_id
  end
end
