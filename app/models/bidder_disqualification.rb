class BidderDisqualification < Compras::Model
  attr_accessible :bidder_id, :reason

  belongs_to :bidder

  validates :bidder, :reason, :presence => true

  def to_s
    bidder.to_s
  end
end
