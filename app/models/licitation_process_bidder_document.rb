class LicitationProcessBidderDocument < ActiveRecord::Base
  attr_accessible :document_type_id, :document_number, :emission_date, :validity

  belongs_to :licitation_process_bidder
  belongs_to :document_type

  delegate :description, :to => :document_type, :allow_nil => true

  validates :document_type, :presence => true

  with_options :allow_blank => true do |allowing_blank|
    allowing_blank.validates :emission_date, :timeliness => { :on_or_before => :today, :type => :date }
  end
end
