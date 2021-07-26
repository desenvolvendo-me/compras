class ReplaceProviderToCreditor < ActiveRecord::Migration

  class DirectPurchase < Compras::Model;end
  class Pledge < Compras::Model;end
  class ReserveFund < Compras::Model;end
  class Precatory < Compras::Model;end
  class PriceCollectionProposal < Compras::Model;end

  def change
    User.where(:authenticable_type => AuthenticableType::PROVIDER).update_all(:authenticable_type => AuthenticableType::CREDITOR)

    add_column :compras_direct_purchases, :creditor_id, :integer
    add_column :compras_licitation_process_bidders, :creditor_id, :integer
    add_column :compras_pledges, :creditor_id, :integer
    add_column :compras_reserve_funds, :creditor_id, :integer
    add_column :compras_precatories, :creditor_id, :integer
    add_column :compras_price_collection_proposals, :creditor_id, :integer
    add_column :compras_creditors, :legal_nature_id, :integer

    add_index :compras_direct_purchases, :creditor_id
    add_index :compras_licitation_process_bidders, :creditor_id
    add_index :compras_pledges, :creditor_id
    add_index :compras_reserve_funds, :creditor_id
    add_index :compras_precatories, :creditor_id
    add_index :compras_price_collection_proposals, :creditor_id
    add_index :compras_creditors, :legal_nature_id
    add_foreign_key :compras_direct_purchases, :compras_creditors, :column => :creditor_id
    add_foreign_key :compras_licitation_process_bidders, :compras_creditors, :column => :creditor_id
    add_foreign_key :compras_pledges, :compras_creditors, :column => :creditor_id
    add_foreign_key :compras_reserve_funds, :compras_creditors, :column => :creditor_id
    add_foreign_key :compras_precatories, :compras_creditors, :column => :creditor_id
    add_foreign_key :compras_price_collection_proposals, :compras_creditors, :column => :creditor_id
    add_foreign_key :compras_creditors, :unico_legal_natures, :column => :legal_nature_id

    [DirectPurchase, Pledge, ReserveFund, Precatory, PriceCollectionProposal].each do |model|
      update_table!(model)
    end
  end

  private

  def update_table!(model)
    model.find_each do |instance|
      next unless instance.provider
      person_id = instance.provider.person_id
      creditor = Creditor.find_or_initialize_by_person_id(person_id)
      creditor.save(:validate => false)
      instance.creditor_id = creditor.id
      instance.save(:validate => false)
    end
  end
end
