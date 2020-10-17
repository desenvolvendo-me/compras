class AuctionCreditorProposalItem < Compras::Model
  attr_accessible :auction_creditor_proposal_id,:auction_item_id,:manufacturer,:model_version,:quantity,:description,:unit_price,:global_price

  belongs_to :auction_creditor_proposal
  belongs_to :auction_item

  has_one :creditor, through: :auction_creditor_proposal

  scope :proposals_ordered_by_item, lambda{|item_id|
    where(auction_item_id: item_id).order(:global_price)
  }


  def proposal_status
    lowest_proposal_item = AuctionCreditorProposalItem.proposals_ordered_by_item(auction_item).first

    lowest_proposal_item.eql?(self) ? 'Vencendo' : 'Com Proposta' #TODO  refatorar depois
  end
end
