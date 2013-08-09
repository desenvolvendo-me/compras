class AddEmailInvitationToPriceCollectionProposals < ActiveRecord::Migration
  def change
    add_column :compras_price_collection_proposals, :email_invitation, :boolean, default: false

    execute <<-SQL
      UPDATE compras_price_collection_proposals
      SET email_invitation = true
    SQL
  end
end
