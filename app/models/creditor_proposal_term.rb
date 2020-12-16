class CreditorProposalTerm < Compras::Model
  attr_accessible :auction_id,:term,:impediment,:proposal_independent,:art_5,:art_93_pcd,:art_529_clt, :user_id,
                  :proposal_doc,:proposal_qualification_doc, :proposal_send_date, :qualification_send_date, :creditor_id,
                  :licitation_process_id

  mount_uploader :proposal_doc, UnicoUploader
  mount_uploader :proposal_qualification_doc, UnicoUploader

  belongs_to :auction
  belongs_to :licitation_process
  belongs_to :user
  belongs_to :creditor

  validates :creditor, :licitation_process_id, presence: true

  before_save :set_proposal_send_date
  before_save :set_qualification_send_date


  def proposals_total_price
    creditor_proposals.sum{|x| x.global_price || 0}
  end

  def creditor_proposal_items_closed
    item_ids = auction.dispute_items.closed.pluck(:auction_item_id)

    creditor_proposals.where(auction_item_id: item_ids)
  end

  private

  def set_proposal_send_date
    if self.proposal_doc_changed?
      self.proposal_send_date = Date.today
    end
  end

  def set_qualification_send_date
    if self.proposal_qualification_doc_changed?
      self.qualification_send_date = Date.today
    end
  end
end
