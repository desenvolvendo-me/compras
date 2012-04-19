class LicitationProcessInvitedBidder < ActiveRecord::Base
  attr_accessible :licitation_process_id, :provider_id, :protocol, :protocol_date, :status
  attr_accessible :receipt_date, :auto_convocation, :licitation_process_invited_bidder_documents_attributes

  has_enumeration_for :status, :with => LicitationProcessInvitedBidderStatus

  belongs_to :licitation_process
  belongs_to :provider

  has_many :licitation_process_invited_bidder_documents, :dependent => :destroy, :order => :id
  has_many :document_types, :through => :licitation_process_invited_bidder_documents

  accepts_nested_attributes_for :licitation_process_invited_bidder_documents, :allow_destroy => true

  validates :provider_id, :protocol, :presence => true
  validates :protocol_date, :receipt_date, :presence =>true, :unless => :auto_convocation

  with_options :allow_blank => true do |allowing_blank|
    allowing_blank.validates :protocol_date, :timeliness => { :on_or_after => :today, :type => :date, :on => :create, :unless => :auto_convocation }
    allowing_blank.validates :receipt_date, :timeliness => { :on_or_after => :protocol_date, :type => :date, :on => :create, :unless => :auto_convocation }
  end

  before_save :clear_dates

  def filled_documents?
    documents = licitation_process_invited_bidder_documents
    return false if documents.empty?

    documents.each do |document|
      return false if document.document_number.blank? ||
                      document.emission_date.blank? ||
                      document.validity.blank?
    end
    true
  end

  protected

  def clear_dates
    if auto_convocation?
      self.protocol_date = nil
      self.receipt_date = nil
    end
  end
end
