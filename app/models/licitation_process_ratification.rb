# encoding: utf-8
class LicitationProcessRatification < Compras::Model
  include Signable

  attr_accessible :adjudication_date, :ratification_date, :licitation_process_id, :creditor_id,
                  :licitation_process_ratification_items_attributes

  attr_modal :sequence, :licitation_process_id, :ratification_date, :adjudication_date

  belongs_to :licitation_process
  belongs_to :creditor

  has_many :licitation_process_ratification_items, :dependent => :destroy
  has_many :creditor_proposals, :through => :licitation_process

  accepts_nested_attributes_for :licitation_process_ratification_items, :allow_destroy => true

  delegate :process, :modality_humanize, :description, :licitation?,
           :to => :licitation_process, :prefix => true, :allow_nil => true

  validates :licitation_process, :creditor, :presence => true
  validates :adjudication_date, :ratification_date, :presence => true
  validate  :creditor_belongs_to_licitation_process, :if => :creditor
  validate  :without_judgment_commission_advice
  validate  :should_have_at_least_one_item

  auto_increment :sequence, :by => :licitation_process_id

  filterize
  orderize :licitation_process_id

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

  def proposals_total_value
    total = self.class.joins { creditor_proposals.item }.
      where { |ratification| ratification.id.eq id }.
      select { sum(creditor_proposals.item.quantity * creditor_proposals.unit_price).
      as(proposal_total) }.first.proposal_total

    BigDecimal(total || 0)
  end

  private

  def without_judgment_commission_advice
    return unless licitation_process && licitation_process_licitation?

    if licitation_process.judgment_commission_advice.nil?
      errors.add(:base, :licitation_process_without_judgment_commission_advices,
                licitation_process: licitation_process.to_s)
    end
  end

  def should_have_at_least_one_item
    if licitation_process_ratification_items.reject(&:marked_for_destruction?).empty?
      errors.add(:licitation_process_ratification_items, :must_have_at_least_one_item)
    end
  end
end
