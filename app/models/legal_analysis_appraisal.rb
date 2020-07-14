class LegalAnalysisAppraisal < Compras::Model
  attr_accessible :appraisal_expedition_date, :appraisal_type, :reference,
                  :responsible_id, :substantiation, :licitation_process_id,
                  :responsible_issuer, :responsible_number

  belongs_to :licitation_process
  belongs_to :responsible, :class_name => "Employee"

  has_many :licitation_process_ratifications, through: :licitation_process

  has_enumeration_for :appraisal_type, create_helpers: { prefix: true }
  has_enumeration_for :reference, :with => AppraisalReference, create_helpers: { prefix: true }
  has_enumeration_for :modality
  has_enumeration_for :responsible_issuer, :with => Issuer

  validates :licitation_process, :appraisal_type, :reference,
            :appraisal_expedition_date, :responsible, :presence => true

  delegate :year, :process, :modality, :description,
    :to => :licitation_process, :allow_nil => true
  delegate :cpf, :name, :street_name, :neighborhood_name, :city_tce_mg_code,
    :state_acronym, :zip_code, :phone, :email,
    to: :responsible, allow_nil: true, prefix: true

  orderize :appraisal_expedition_date

  scope :by_ratification_month_and_year, lambda { |month, year|
    joins { licitation_process.licitation_process_ratifications }.
      where(%{
        extract(month from compras_licitation_process_ratifications.ratification_date) = ? AND
        extract(year from compras_licitation_process_ratifications.ratification_date) = ?},
        month, year)
  }

  scope :type_of_purchase_licitation, -> { joins { licitation_process }.
    where { licitation_process.type_of_purchase.eq(PurchaseProcessTypeOfPurchase::LICITATION) }
  }

  def process_and_year
    "#{process}/#{year}"
  end

  def to_s
    reference_humanize
  end
end
