class AuctionCreditorProposalItem < Compras::Model
  attr_accessible :auction_creditor_proposal_id,:auction_item_id,:manufacturer,:model_version,:quantity,:description,:unit_price,:global_price

  belongs_to :auction_creditor_proposal
  belongs_to :auction_item
end
