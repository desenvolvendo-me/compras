class CreditorDocument < Compras::Model
  attr_accessible :document_type_id, :document_number, :emission_date, :validity
  attr_accessible :issuer

  belongs_to :creditor
  belongs_to :document_type

  delegate :description, :to => :document_type, :allow_nil => true

  validates :document_type, :document_number, :emission_date, :validity, :issuer, :presence => true
  validates :emission_date,
    :timeliness => { :on_or_before => :today, :type => :date },
    :allow_blank => true
  validates :validity,
    :timeliness => { :on_or_after => :emission_date, :type => :date },
    :allow_blank => true
end
