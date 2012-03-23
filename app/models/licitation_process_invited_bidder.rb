class LicitationProcessInvitedBidder < ActiveRecord::Base
  attr_accessible :licitation_process_id, :provider_id, :protocol, :protocol_date
  attr_accessible :receipt_date, :auto_convocation

  belongs_to :licitation_process
  belongs_to :provider

  validates :provider_id, :protocol, :presence => true
  validates :protocol_date, :receipt_date, :presence =>true, :unless => :auto_convocation
  validates :protocol_date, :timeliness => { :on_or_after => :today, :type => :date, :on => :create, :unless => :auto_convocation }
  validates :receipt_date, :timeliness => { :on_or_after => :protocol_date, :type => :date, :on => :create, :unless => :auto_convocation }

  before_save :clear_dates_if_auto_convocation

  protected

  def clear_dates_if_auto_convocation
    if auto_convocation
      self.protocol_date = nil
      self.receipt_date = nil
    end
  end
end
