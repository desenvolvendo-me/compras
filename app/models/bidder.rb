class Bidder < Compras::Model
  attr_accessible :licitation_process_id, :creditor_id, :protocol, :protocol_date,
                  :receipt_date, :invited, :documents_attributes, :proposals_attributes,
                  :technical_score, :person_ids, :licitation_process_id,
                  :enabled, :renounce_resource,
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
  has_many :licitation_process_ratifications, :dependent => :restrict
  has_many :items, :through => :licitation_process

  has_one :judgment_form, :through => :licitation_process

  delegate :document_type_ids, :process_date, :ratification?, :has_trading?,
           :invitation?,
           :to => :licitation_process, :prefix => true, :allow_nil => true
  delegate :envelope_opening?, :allow_bidders?,
           :to => :licitation_process, :allow_nil => true
  delegate :benefited, :to => :creditor, :allow_nil => true

  accepts_nested_attributes_for :documents, :allow_destroy => true
  accepts_nested_attributes_for :proposals, :allow_destroy => true

  validates :creditor, :presence => true
  validates :protocol, :protocol_date, :receipt_date, :presence => true, :if => :invited
  validates :creditor_id, :uniqueness => { :scope => :licitation_process_id, :allow_blank => true }
  validates :technical_score, :presence => true, :if => :validate_technical_score?
  validates :documents, no_duplication: :document_type_id
  validate :block_licitation_process_with_ratification

  with_options :allow_blank => true do |allowing_blank|
    allowing_blank.validates :protocol_date,
      :timeliness => {
        :on_or_after => :today,
        :on_or_after_message => :should_be_on_or_after_today,
        :type => :date,
        :on => :create,
        :if => :invited
      }
    allowing_blank.validates :receipt_date,
      :timeliness => {
        :on_or_after => :protocol_date,
        :on_or_after_message => :should_be_on_or_after_protocol_date,
        :type => :date,
        :on => :create,
        :if => :invited
      }
  end

  before_save :clear_invited_data, :set_default_values

  orderize "id DESC"
  filterize

  scope :exclude_ids, lambda { |ids|  where { id.not_in(ids) } }

  def self.benefited
    joins { creditor.person.personable(Company).company_size.extended_company_size }.
    where { 'compras_extended_company_sizes.benefited = true' }
  end

  def self.won_calculation
    joins { licitation_process_classifications }.
    where { licitation_process_classifications.situation.eq(SituationOfProposal::WON) }
  end

  def self.without_ratification
    joins { licitation_process_ratifications.outer }.
    where { licitation_process_ratifications.id.eq(nil) }
  end

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

  protected

  def block_licitation_process_with_ratification
    return unless licitation_process.present?

    if licitation_process_ratification?
      errors.add(:base, :cannot_be_changed_when_the_licitation_process_has_a_ratification, :licitation_process => licitation_process)
    end
  end

  def classification_percent(first_place_amount, current_amount)
    ((current_amount - first_place_amount) / first_place_amount) * BigDecimal(100)
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

  def validate_technical_score?
    return unless judgment_form.present?

    judgment_form.best_technique? || judgment_form.technical_and_price?
  end
end
