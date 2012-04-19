class InvitedBidderStatusChanger
  attr_accessor :licitation_process

  delegate :licitation_process_invited_bidders, :to => :licitation_process

  def initialize(licitation_process)
    self.licitation_process = licitation_process
  end

  def change
    licitation_process_invited_bidders.each do |invited_bidder|
      if invited_bidder.filled_documents?
        invited_bidder.status = enabled_status
      else
        invited_bidder.status = disabled_status
      end
    end
  end

  def enabled_status
    LicitationProcessInvitedBidderStatus::ENABLED
  end

  def disabled_status
    LicitationProcessInvitedBidderStatus::DISABLED
  end
end
