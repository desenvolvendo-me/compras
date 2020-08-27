class PurchaseProcessDocumentObserver < ActiveRecord::Observer
  observe :licitation_process

  def before_update(licitation_process)
    licitation_process.bidders.each do |bidder|
      if licitation_process.document_type_ids != bidder.document_type_ids
        bidder.assign_document_types
        bidder.save!
      end
    end
  end
end
