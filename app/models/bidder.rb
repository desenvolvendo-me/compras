class Bidder < Compras::Model
  attr_accessible :licitation_process_id, :creditor_id, :protocol, :protocol_date,
                  :receipt_date, :invited, :documents_attributes, :proposals_attributes,
                  :technical_score, :person_ids, :licitation_process_id,
                  :enabled, :renounce_resource, :habilitation_date,
                  :recording_attendance

  attr_modal :licitation_process_id, :creditor_id, :protocol, :protocol_date

  belongs_to :licitation_process
  belongs_to :creditor

  has_many :documents, :class_name => :BidderDocument, :dependent => :destroy, :order => :id
  has_many :document_types, :through => :documents
  has_many :proposals, :class_name => :BidderProposal, :dependent => :destroy, :order => :id
  has_many :accredited_representatives, :dependent => :destroy
  has_many :people, :through => :accredited_representatives
  has_many :licitation_process_classifications, :dependent => :destroy
  has_many :licitation_process_classifications_by_classifiable, :as => :classifiable, :dependent => :destroy, :class_name => 'LicitationProcessClassification'
  has_many :licitation_process_ratifications, through: :creditor
  has_many :items, :through => :licitation_process

  has_one :judgment_form, :through => :licitation_process

  delegate :document_type_ids, :process_date, :ratification?, :has_trading?,
           :invitation?, :year, :process,
           :to => :licitation_process, :prefix => true, :allow_nil => true
  delegate :envelope_opening?, :execution_unit_responsible,
           :to => :licitation_process, :allow_nil => true
  delegate :benefited, :company?, :identity_document, :name, :state_registration,
    :uf_state_registration,
    :to => :creditor, :allow_nil => true
  delegate :organ_responsible_for_registration, :commercial_registration_date,
    :company_partners, :commercial_registration_number,
    to: :creditor, allow_nil: true, prefix: true

  accepts_nested_attributes_for :documents, :allow_destroy => true
  accepts_nested_attributes_for :proposals, :allow_destroy => true

  validates :creditor, :presence => true
  validates :protocol, :protocol_date, :receipt_date, :presence => true, :if => :invited
  validates :creditor_id, :uniqueness => { :scope => :licitation_process_id, :allow_blank => true }
  validates :technical_score, :presence => true, if: :validate_technical_score?
  validates :documents, no_duplication: :document_type_id
  validate :block_licitation_process_with_ratification

  validates :receipt_date,
      :timeliness => {
        :on_or_after => :protocol_date,
        :on_or_after_message => :should_be_on_or_after_protocol_date,
        :type => :date,
        :on => :create,
        :if => :invited
      }, allow_blank: true

  before_save :clear_invited_data, :set_default_values
  after_save :update_proposal_ranking, if: :enabled_changed?
  after_save :set_status_licitation
  before_save :block_changes_when_have_ratifications

  orderize "id DESC"
  filterize

  scope :by_ratification_month_and_year, lambda { |month, year|
    joins { licitation_process_ratifications }.
    where(%{
      extract(month from compras_licitation_process_ratifications.ratification_date) = ? AND
      extract(year from compras_licitation_process_ratifications.ratification_date) = ?},
      month, year)
  }

  scope :enabled, lambda {
    where { enabled.eq(true) }
  }

  scope :benefited, lambda {
    joins { creditor.person.personable(Company).company_size.extended_company_size }.
    where { 'compras_extended_company_sizes.benefited = true' }
  }

  scope :won_calculation, lambda {
    joins { licitation_process.creditor_proposals }.
    where { licitation_process.creditor_proposals.ranking.eq(1) }.
    where { '"compras_bidders".creditor_id = "compras_purchase_process_creditor_proposals".creditor_id' }.
    uniq
  }

  scope :type_of_purchase_licitation, -> { joins { licitation_process }.
    where { licitation_process.type_of_purchase.eq(PurchaseProcessTypeOfPurchase::LICITATION) }
  }

  def destroy_all_classifications
    licitation_process_classifications.destroy_all
  end

  def filled_documents?
    return false if documents.empty?

    documents.each do |document|
      return false if document.document_number.blank? ||
                      document.emission_date.blank? ||
                      document.validity.blank?
    end
    true
  end

  def expired_documents?
    documents.each do |document|
      return true if document.expired?
    end

    false
  end

  def has_proposals_unit_price_greater_than_budget_allocation_item_unit_price?
    proposals.select(&:unit_price_greater_than_budget_allocation_item_unit_price?).any?
  end

  def to_s
    creditor.to_s
  end

  def assign_document_types
    self.document_type_ids = licitation_process_document_type_ids
  end

  def build_documents
    licitation_process_document_type_ids.each do |document_type_id|
      documents.build(document_type_id: document_type_id, purchase_document: true)
    end
  end

  def purchase_process_documents
    documents.select { |d| d.purchase_document? }
  end

  def bidder_documents
    documents.select { |d| !d.purchase_document? }
  end

  def proposal_total_value
    total = self.class.joins { proposals.purchase_process_item }.
      where { |bidder| bidder.id.eq id }.
      select { sum(proposals.purchase_process_item.quantity * proposals.unit_price).as(proposal_total) }.first.proposal_total

    BigDecimal(total || 0)
  end

  def has_item_with_unit_price_equals_zero(lot = nil)
    proposals.any_without_unit_price?(lot)
  end

  def total_price
    return BigDecimal(0) if proposals.empty?

    proposals.sum(&:total_price)
  end

  def benefited_by_law_of_proposals?
    benefited
  end

  def inactivate!
    update_column(:enabled, false)
  end

  def activate!
    update_column(:enabled, true)
  end

  def has_documentation_problem?
    !filled_documents? || expired_documents?
  end

  def validate_technical_score?
    return unless judgment_form.present?

    judgment_form.best_technique? || judgment_form.technical_and_price?
  end

  protected

  def update_proposal_ranking
    return unless licitation_process

    licitation_process.proposals_of_creditor(creditor).each do |creditor_proposal|
      PurchaseProcessCreditorProposalRanking.rank! creditor_proposal
    end
  end

  def block_licitation_process_with_ratification
    return unless licitation_process.present?

    if licitation_process_ratification?
      errors.add(:base, :cannot_be_changed_when_the_licitation_process_has_a_ratification, :licitation_process => licitation_process)
    end
  end

  def clear_invited_data
    unless invited?
      self.protocol = nil
      self.protocol_date = nil
      self.receipt_date = nil
    end
  end

  def set_default_values
    proposals.each do |proposal|
      proposal.situation = nil
      proposal.classification = nil
      proposal.unit_price = 0 unless proposal.unit_price
    end
  end

  def set_status_licitation
    PurchaseProcessStatusChanger.new(licitation_process).in_progress!
  end

  def block_changes_when_have_ratifications
    return unless licitation_process.ratification?

    raise ActiveRecord::RecordNotFound
  end

end
