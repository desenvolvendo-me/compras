class CreditorDocument < Compras::Model
  attr_accessible :document_type_id, :document_number, :emission_date,
              :validity, :issuer

  has_enumeration_for :issuer

  belongs_to :creditor
  belongs_to :document_type

  delegate :description, :to => :document_type, :allow_nil => true

  validates :document_type, :document_number, :emission_date, :validity, :issuer,
            :presence => true
  validates :emission_date,
    :timeliness => {
      :on_or_before => :today,
      :type => :date,
      :on_or_before_message => :should_be_on_or_before_today
    },
    :allow_blank => true
  validates :validity,
    :timeliness => {
      :on_or_after => :emission_date,
      :type => :date,
      :on_or_after_message => :validity_should_be_on_or_after_emission_date
    },
    :allow_blank => true

  def to_s
    document_type
  end
end
