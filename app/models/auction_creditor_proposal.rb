class AuctionCreditorProposal < Compras::Model
  attr_accessible :auction_id,:term,:impediment,:proposal_independent,:art_5,:art_93_pcd,:art_529_clt, :user_id,
                  :proposal_doc,:proposal_qualification_doc, :auction_creditor_proposal_items_attributes

  mount_uploader :proposal_doc, UnicoUploader
  mount_uploader :proposal_qualification_doc, UnicoUploader

  belongs_to :auction
  belongs_to :user

  has_many :auction_creditor_proposal_items

  accepts_nested_attributes_for :auction_creditor_proposal_items, :allow_destroy => true

end
