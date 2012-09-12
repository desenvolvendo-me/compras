class Agreement < Compras::Model
  attr_accessible :category, :code, :counterpart_value, :description,
                  :parcels_number, :process_date, :value,
                  :number_year, :number_year_process, :agreement_kind_id,
                  :regulatory_act_id, :agreement_file,
                  :agreement_bank_accounts_attributes,
                  :agreement_occurrences_attributes,
                  :agreement_participants_attributes,
                  :agreement_additives_attributes

  attr_modal :code, :description, :process_date, :regulatory_act_id, :category

  mount_uploader :agreement_file, DocumentUploader

  has_enumeration_for :category, :with => AgreementCategory
  has_enumeration_for :status, :create_helpers => true

  belongs_to :agreement_kind
  belongs_to :regulatory_act

  has_many :agreement_additives, :dependent => :destroy, :order => :number
  has_many :agreement_participants, :dependent => :destroy
  has_many :agreement_occurrences, :dependent => :destroy, :order => 'date desc', :inverse_of => :agreement
  has_many :agreement_bank_accounts, :dependent => :destroy, :order => :id
  has_many :tce_capability_agreements, :dependent => :restrict
  has_many :tce_specification_capabilities, :through => :tce_capability_agreements,
           :dependent => :restrict

  accepts_nested_attributes_for :agreement_bank_accounts, :allow_destroy => true
  accepts_nested_attributes_for :agreement_occurrences, :allow_destroy => true
  accepts_nested_attributes_for :agreement_participants, :allow_destroy => true
  accepts_nested_attributes_for :agreement_additives, :allow_destroy => true

  delegate :creation_date, :publication_date, :end_date, :to => :regulatory_act,
           :allow_nil => true

  validates :code, :number_year, :category, :agreement_kind, :value,
            :counterpart_value, :parcels_number, :description,
            :number_year_process, :regulatory_act, :process_date,
            :presence => true
  validates :number_year, :number_year_process, :format => /^(\d+)\/\d{4}$/

  orderize :description
  filterize

  scope :actives,
    joins { agreement_occurrences }.
    where { agreement_occurrences.kind.eq(AgreementOccurrenceKind::IN_PROGRESS) }

  def last_additive_number
    return 0 unless last_persisted_additive

    last_persisted_additive.number
  end

  def to_s
    description
  end

  def status
    if first_agreement_occurrence_is_active?
      Status::ACTIVE
    else
      Status::INACTIVE
    end
  end

  def year
    number_year.split('/').last
  end

  protected

  def first_agreement_occurrence_is_active?
    return if agreement_occurrences.blank?

    agreement_occurrences.first.active?
  end

  def last_persisted_additive
    agreement_additives.select(&:persisted?).last
  end
end
