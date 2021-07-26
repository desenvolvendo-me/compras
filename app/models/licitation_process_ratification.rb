class LicitationProcessRatification < Compras::Model
  include Signable

  attr_accessible :adjudication_date, :ratification_date, :licitation_process_id, :creditor_id,
                  :licitation_process_ratification_items_attributes

  attr_modal :sequence, :licitation_process_id, :ratification_date, :adjudication_date

  belongs_to :licitation_process
  belongs_to :creditor

  has_many :licitation_process_ratification_items, :dependent => :destroy
  has_many :creditor_proposals, :through => :licitation_process

  has_one :judgment_form, through: :licitation_process

  accepts_nested_attributes_for :licitation_process_ratification_items, :allow_destroy => true

  delegate :process, :modality_humanize, :description, :licitation?, :trading?,
    :execution_unit_responsible,
    :to => :licitation_process, :prefix => true, :allow_nil => true
  delegate :item?, to: :judgment_form, allow_nil: true, prefix: true
  delegate :process_responsibles, to: :licitation_process, allow_nil: true
  delegate :year, :process, :type_of_purchase_humanize, :modality_humanize, :type_of_removal_humanize,
    :licitation?, to: :licitation_process, allow_nil: true, prefix: true

  validates :licitation_process, :creditor, :presence => true
  validates :adjudication_date, :ratification_date, :presence => true
  validate  :creditor_belongs_to_licitation_process, :if => :creditor
  validate  :should_have_at_least_one_item

  after_destroy :update_licitation_process_status_to_in_progress,
    unless: :licitation_process_got_ratifications?

  auto_increment :sequence, :by => :licitation_process_id

  filterize
  orderize :licitation_process_id

  scope :licitation_process_id, ->(licitation_process_id) do
    where { |query|
      query.licitation_process_id.eq(licitation_process_id)
    }
  end

  def to_s
    "#{sequence} - Processo de Compra #{licitation_process.to_s}"
  end

  def creditor_belongs_to_licitation_process
    unless licitation_process.creditors.include?(creditor)
      errors.add(:creditor,
                 :should_belongs_to_licitation_process,
                 :licitation_process => licitation_process,
                 :creditor => creditor.to_s)
    end
  end

  def creditor_proposals_total_value
    creditor_proposals.creditor_id(creditor_id).sum {|proposal| proposal.total_price }
  end

  def proposals_total_value
    total = self.class.joins { creditor_proposals.item }.
      where { |ratification| ratification.id.eq id }.
      select { sum(creditor_proposals.item.quantity * creditor_proposals.unit_price).
      as(proposal_total) }.first.proposal_total

    BigDecimal(total || 0)
  end

  def has_realignment_price?
    !judgment_form_item?
  end

  private

  def should_have_at_least_one_item
    if licitation_process_ratification_items.reject(&:marked_for_destruction?).empty?
      errors.add(:licitation_process_ratification_items, :must_have_at_least_one_item)
    end
  end

  def update_licitation_process_status_to_in_progress
    PurchaseProcessStatusChanger.new(licitation_process).in_progress!
  end

  def licitation_process_got_ratifications?
    licitation_process.licitation_process_ratifications.any?
  end

end
