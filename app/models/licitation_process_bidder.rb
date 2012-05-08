class LicitationProcessBidder < ActiveRecord::Base
  attr_accessible :licitation_process_id, :provider_id, :protocol, :protocol_date, :status
  attr_accessible :receipt_date, :invited, :documents_attributes

  has_enumeration_for :status, :with => LicitationProcessBidderStatus

  belongs_to :licitation_process
  belongs_to :provider

  has_many :documents, :class_name => :LicitationProcessBidderDocument, :dependent => :destroy, :order => :id
  has_many :document_types, :through => :documents

  delegate :document_type_ids, :process_date, :to => :licitation_process, :prefix => true
  delegate :administrative_process, :to => :licitation_process
  delegate :invited?, :to => :administrative_process, :prefix => true

  accepts_nested_attributes_for :documents, :allow_destroy => true

  validates :provider, :presence => true
  validates :protocol, :protocol_date, :receipt_date, :presence => true, :if => :invited
  validates :provider_id, :uniqueness => { :scope => :licitation_process_id, :allow_blank => true }

  with_options :allow_blank => true do |allowing_blank|
    allowing_blank.validates :protocol_date, :timeliness => { :on_or_after => :today, :type => :date, :on => :create, :if => :invited }
    allowing_blank.validates :receipt_date, :timeliness => { :on_or_after => :protocol_date, :type => :date, :on => :create, :if => :invited }
  end

  before_save :clear_data_unless_invited

  orderize :id
  filterize

  def filled_documents?
    return false if documents.empty?

    documents.each do |document|
      return false if document.document_number.blank? ||
                      document.emission_date.blank? ||
                      document.validity.blank?
    end
    true
  end

  def to_s
    "#{licitation_process} - #{id}"
  end

  def assign_document_types
    self.document_type_ids = licitation_process_document_type_ids
  end

  def build_documents
    licitation_process_document_type_ids.each do |document_type_id|
      documents.build(:document_type_id => document_type_id)
    end
  end

  protected

  def clear_data_unless_invited
    unless invited?
      self.protocol = nil
      self.protocol_date = nil
      self.receipt_date = nil
    end
  end
end
