class BidderStatusChanger
  attr_accessor :licitation_process, :licitation_process_bidder_status

  delegate :licitation_process_bidders, :to => :licitation_process

  def initialize(licitation_process, licitation_process_bidder_status = LicitationProcessBidderStatus)
    self.licitation_process = licitation_process
    self.licitation_process_bidder_status = licitation_process_bidder_status
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

  private

  def enabled_status
    licitation_process_bidder_status.value_for(:ENABLED)
  end

  def disabled_status
    licitation_process_bidder_status.value_for(:DISABLED)
  end
end
