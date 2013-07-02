class MigrateRealignmentPriceData < ActiveRecord::Migration
  def up
    RealignmentPriceItem.find_each do |item|
      proposal = PurchaseProcessCreditorProposal.find item.purchase_process_creditor_proposal_id
      realignment = RealignmentPrice.find_or_create_by_purchase_process_id_and_creditor_id_and_lot(
        purchase_process_id: proposal.licitation_process_id,
        creditor_id: proposal.creditor_id,
        lot: proposal.lot)

      item.update_column :realignment_price_id, realignment.id
    end
  end

  def down
    RealignmentPrice.destroy_all

    RealignmentPriceItem.find_each do |item|
      item.update_column :realignment_price_id, nil
    end
  end
end
