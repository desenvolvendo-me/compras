class AddIndexOnCurrencyIdOnIndexers < ActiveRecord::Migration
  def change
    add_index :indexers, :currency_id
  end
end
