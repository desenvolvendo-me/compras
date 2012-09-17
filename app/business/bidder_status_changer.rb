class BidderStatusChanger
  attr_accessor :licitation_process, :status

  delegate :bidders, :to => :licitation_process

  def initialize(licitation_process, status = Status)
    self.licitation_process = licitation_process
    self.status = status
  end

  def change
    bidders.each do |bidder|
      if bidder.filled_documents?
        bidder.status = active_status
      else
        bidder.status = inactive_status
      end
    end
  end

  private

  def active_status
    status.value_for(:ACTIVE)
  end

  def inactive_status
    status.value_for(:INACTIVE)
  end
end
