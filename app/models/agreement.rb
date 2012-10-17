class Agreement < Compras::Model
  attr_accessible :category, :counterpart_value, :description,
                  :parcels_number, :process_date, :value,
                  :number_year, :number_year_process, :agreement_kind_id,
                  :regulatory_act_id,
                  :agreement_bank_accounts_attributes,
                  :agreement_occurrences_attributes,
                  :agreement_participants_attributes,
                  :agreement_additives_attributes,
                  :agreement_files_attributes

  attr_modal :description, :process_date, :regulatory_act_id, :category

  has_enumeration_for :category, :with => AgreementCategory
  has_enumeration_for :status, :create_helpers => true

  belongs_to :agreement_kind
  belongs_to :regulatory_act

  has_many :agreement_additives, :dependent => :destroy, :order => :number
  has_many :agreement_files, :dependent => :destroy, :order => :id
  has_many :agreement_participants, :dependent => :destroy, :order => :id, :inverse_of => :agreement
  has_many :agreement_occurrences, :dependent => :destroy, :order => [AgreementOccurrence.arel_table[:date].desc], :inverse_of => :agreement
  has_many :agreement_bank_accounts, :dependent => :destroy, :order => [AgreementBankAccount.arel_table[:creation_date].desc,
                                                                        AgreementBankAccount.arel_table[:status]]
  has_many :tce_capability_agreements, :dependent => :restrict
  has_many :tce_specification_capabilities, :through => :tce_capability_agreements,
           :dependent => :restrict

  delegate :date, :active?, :kind_humanize, :to => :first_occurrence, :allow_nil => true, :prefix => true

  orderize :description
  filterize

  scope :actives,
    joins { agreement_occurrences }.
    where { agreement_occurrences.kind.eq(AgreementOccurrenceKind::IN_PROGRESS) }

  def status
    if first_occurrence_active?
      Status::ACTIVE
    else
      Status::INACTIVE
    end
  end

  protected

  def first_occurrence
    return if agreement_occurrences.blank?

    agreement_occurrences.first
  end
end
