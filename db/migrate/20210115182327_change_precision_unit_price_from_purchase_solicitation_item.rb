class ChangePrecisionUnitPriceFromPurchaseSolicitationItem < ActiveRecord::Migration
  def change
    # problem: https://stackoverflow.com/questions/2450494/rails-cannot-add-precision-or-scale-options-with-change-column-in-a-migration
    # solution: https://stackoverflow.com/questions/10343383/rails-migrations-tried-to-change-the-type-of-column-from-string-to-integer
    execute "ALTER TABLE public.compras_purchase_process_items ALTER COLUMN unit_price TYPE DECIMAL(10,3)"
  end
end
