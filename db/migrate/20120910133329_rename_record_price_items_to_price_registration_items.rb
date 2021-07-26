class RenameRecordPriceItemsToPriceRegistrationItems < ActiveRecord::Migration
  def change
    rename_table :compras_record_price_items, :compras_price_registration_items

    rename_column :compras_price_registration_items,
                  :record_price_id, :price_registration_id
  end
end
