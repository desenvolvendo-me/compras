class LicitationProcessBidderDocument < Compras::Model
  attr_accessible :document_type_id, :document_number, :emission_date, :validity

  belongs_to :licitation_process_bidder
  belongs_to :document_type

  delegate :description, :to => :document_type, :allow_nil => true

  validates :document_type, :presence => true
  validates :emission_date, :timeliness => { :on_or_before => :today, :type => :date }, :allow_blank => true
  validates :validity, :timeliness => { :on_or_after => :emission_date, :type => :date }, :allow_blank => true
end
