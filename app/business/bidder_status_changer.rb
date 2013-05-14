class BidderStatusChanger
  attr_accessor :licitation_process

  delegate :bidders, :to => :licitation_process

  def initialize(licitation_process)
    self.licitation_process = licitation_process
  end

  def change
    bidders.each do |bidder|
      if bidder.filled_documents?
        bidder.enabled = active
      else
        bidder.enabled = inactive
      end
    end
  end

  private

  def active
    true
  end

  def inactive
    false
  end
end
