class BidderStatusChanger
  attr_accessor :licitation_process

  delegate :licitation_process_bidders, :to => :licitation_process

  def initialize(licitation_process)
    self.licitation_process = licitation_process
  end

  def change
    licitation_process_bidders.each do |bidder|
      if bidder.filled_documents?
        bidder.status = enabled_status
      else
        bidder.status = disabled_status
      end
    end
  end

  def enabled_status
    LicitationProcessBidderStatus::ENABLED
  end

  def disabled_status
    LicitationProcessBidderStatus::DISABLED
  end
end
