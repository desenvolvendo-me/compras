class LegalAnalysisAppraisal < Compras::Model
  attr_accessible :appraisal_expedition_date, :appraisal_type, :reference, :responsible_id, :substantiation, :licitation_process_id

  belongs_to :licitation_process
  belongs_to :responsible, :class_name => "Employee"

  has_enumeration_for :appraisal_type
  has_enumeration_for :reference, :with => AppraisalReference
  has_enumeration_for :modality

  validates :licitation_process, :appraisal_type, :reference, :appraisal_expedition_date, :responsible, :presence => true

  delegate :year, :process, :modality, :description, :to => :licitation_process, :allow_nil => true
  delegate :number, :issuer, :to => :responsible, :prefix => true, :allow_nil => :true

  orderize :appraisal_expedition_date

  def process_and_year
    "#{process}/#{year}"
  end

  def to_s
    reference_humanize
  end
end
