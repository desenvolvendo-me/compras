class RemoveProvider < ActiveRecord::Migration
  def change
    remove_column   :compras_direct_purchases, :provider_id
    remove_column   :compras_licitation_process_bidders, :provider_id
    remove_column   :compras_pledges, :provider_id
    remove_column   :compras_reserve_funds, :provider_id
    remove_column   :compras_precatories, :provider_id
    remove_column   :compras_price_collection_proposals, :provider_id

    drop_table :compras_materials_classes_compras_providers
    drop_table :compras_materials_groups_compras_providers
    drop_table :compras_materials_compras_providers
    drop_table :compras_provider_partners
    drop_table :compras_provider_licitation_documents
    drop_table :compras_providers
  end
end
