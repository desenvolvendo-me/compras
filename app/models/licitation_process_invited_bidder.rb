class LicitationProcessInvitedBidder < ActiveRecord::Base
  attr_accessible :licitation_process_id, :provider_id, :protocol, :protocol_date
  attr_accessible :receipt_date, :auto_convocation, :licitation_process_invited_bidder_documents_attributes

  belongs_to :licitation_process
  belongs_to :provider

  has_many :licitation_process_invited_bidder_documents, :dependent => :destroy, :order => :id
  has_many :document_types, :through => :licitation_process_invited_bidder_documents

  accepts_nested_attributes_for :licitation_process_invited_bidder_documents, :allow_destroy => true

  validates :provider_id, :protocol, :presence => true
  validates :protocol_date, :receipt_date, :presence =>true, :unless => :auto_convocation

  with_options :allow_blank => true do |allowed_blank|
    allowed_blank.validates :protocol_date, :timeliness => { :on_or_after => :today, :type => :date, :on => :create, :unless => :auto_convocation }
    allowed_blank.validates :receipt_date, :timeliness => { :on_or_after => :protocol_date, :type => :date, :on => :create, :unless => :auto_convocation }
  end

  before_save :clear_dates_if_auto_convocation

  protected

  def clear_dates_if_auto_convocation
    if auto_convocation?
      self.protocol_date = nil
      self.receipt_date = nil
    end
  end
end
