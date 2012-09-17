class BidderDocument < Compras::Model
  attr_accessible :document_type_id, :document_number, :emission_date, :validity

  belongs_to :bidder
  belongs_to :document_type

  delegate :description, :to => :document_type, :allow_nil => true

  validates :document_type, :presence => true
  validates :emission_date,
    :timeliness => {
      :on_or_before => :today,
      :type => :date,
      :on_or_before_message => :should_be_on_or_before_today
    }, :allow_blank => true
  validates :validity,
    :timeliness => {
      :type => :date,
      :on_or_after => :emission_date,
      :on_or_after_message => :validity_should_be_on_or_after_emission_date
    }, :allow_blank => true

  def expired?
    validity && validity < Date.current
  end
end
