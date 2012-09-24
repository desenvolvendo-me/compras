class Agreement < Compras::Model
  attr_accessible :category, :counterpart_value, :description,
                  :parcels_number, :process_date, :value,
                  :number_year, :number_year_process, :agreement_kind_id,
                  :regulatory_act_id, :agreement_file,
                  :agreement_bank_accounts_attributes,
                  :agreement_occurrences_attributes,
                  :agreement_participants_attributes,
                  :agreement_additives_attributes

  attr_modal :description, :process_date, :regulatory_act_id, :category

  mount_uploader :agreement_file, DocumentUploader

  has_enumeration_for :category, :with => AgreementCategory
  has_enumeration_for :status, :create_helpers => true

  belongs_to :agreement_kind
  belongs_to :regulatory_act

  has_many :agreement_additives, :dependent => :destroy, :order => :number
  has_many :agreement_participants, :dependent => :destroy, :order => :id, :inverse_of => :agreement
  has_many :agreement_occurrences, :dependent => :destroy, :order => [AgreementOccurrence.arel_table[:date].desc], :inverse_of => :agreement
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
  delegate :date, :active?, :kind_humanize, :to => :first_occurrence, :allow_nil => true, :prefix => true

  validates :number_year, :category, :agreement_kind, :value,
            :counterpart_value, :parcels_number, :description,
            :number_year_process, :regulatory_act, :process_date,
            :presence => true
  validates :number_year, :number_year_process, :format => /^(\d+)\/\d{4}$/
  validates :agreement_bank_accounts, :no_duplication => :bank_account_id
  validate :if_sum_of_participants_granting_equals_total_value
  validate :if_sum_of_participants_convenente_equals_total_value

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
    if first_occurrence_active?
      Status::ACTIVE
    else
      Status::INACTIVE
    end
  end

  def year
    number_year.split('/').last
  end

  def persisted_and_has_occurrences?
    persisted? && agreement_occurrences.present?
  end

  protected

  def if_sum_of_participants_granting_equals_total_value(numeric_parser = ::I18n::Alchemy::NumericParser)
    return if agreement_participants.blank? || total_value.blank?

    total_granting = sum_value_of_participants_granting

    if total_granting != total_value
      errors.add :agreement_participants, :agreement_participants_granting_should_be_equals_total,
                 :total => numeric_parser.localize(total_value)
    end
  end

  def if_sum_of_participants_convenente_equals_total_value(numeric_parser = ::I18n::Alchemy::NumericParser)
    return if agreement_participants.blank? || total_value.blank?

    total_convenente = sum_value_of_participants_convenente

    if total_convenente != total_value
      errors.add :agreement_participants, :agreement_participants_convenente_should_be_equals_total,
                 :total => numeric_parser.localize(total_value)
    end
  end

  def total_value
    value.to_f + counterpart_value.to_f
  end

  def sum_value_of_participants_granting
    agreement_participants.reject(&:marked_for_destruction?).select(&:granting?).sum(&:value)
  end

  def sum_value_of_participants_convenente
    agreement_participants.reject(&:marked_for_destruction?).select(&:convenente?).sum(&:value)
  end

  def first_occurrence
    return if agreement_occurrences.blank?

    agreement_occurrences.first
  end

  def last_persisted_additive
    agreement_additives.select(&:persisted?).last
  end
end
