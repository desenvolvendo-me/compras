class LicitationProcessInvitedBidderDocument < ActiveRecord::Base
  attr_accessible :document_type_id, :document_number, :emission_date, :validity

  belongs_to :licitation_process_invited_bidder
  belongs_to :document_type

  delegate :description, :to => :document_type, :allow_nil => true

  validates :document_type, :document_number, :emission_date, :validity, :presence => true
end
