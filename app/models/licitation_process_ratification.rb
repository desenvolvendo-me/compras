# encoding: utf-8
class LicitationProcessRatification < Compras::Model
  include Signable

  attr_accessible :adjudication_date, :ratification_date, :licitation_process_id, :licitation_process_bidder_id
  attr_accessible :licitation_process_ratification_items_attributes

  attr_modal :sequence, :licitation_process_id, :ratification_date, :adjudication_date

  belongs_to :licitation_process
  belongs_to :licitation_process_bidder

  has_many :licitation_process_ratification_items, :dependent => :destroy
  has_many :licitation_process_bidder_proposals, :through => :licitation_process_ratification_items

  accepts_nested_attributes_for :licitation_process_ratification_items, :allow_destroy => true

  delegate :process, :administrative_process_modality_humanize,
           :administrative_process_description,
           :to => :licitation_process, :prefix => true, :allow_nil => true

  validates :licitation_process, :licitation_process_bidder, :presence => true
  validates :adjudication_date, :ratification_date, :presence => true
  validate :licitation_process_bidder_belongs_to_licitation_process, :if => :licitation_process_bidder

  auto_increment :sequence, :by => :licitation_process_id

  filterize
  orderize :licitation_process_id

  def to_s
    "#{sequence} - Processo Licitatório #{licitation_process.to_s}"
  end

  def licitation_process_bidder_belongs_to_licitation_process
    if licitation_process_bidder.licitation_process != licitation_process
      errors.add(:licitation_process_bidder,
                 :should_belongs_to_licitation_process,
                 :licitation_process => licitation_process)
    end
  end

  def proposals_total_value
    total = self.class.joins { licitation_process_bidder_proposals.administrative_process_budget_allocation_item }.
      where { |ratification| ratification.id.eq id }.
      select { sum(licitation_process_bidder_proposals.administrative_process_budget_allocation_item.quantity * licitation_process_bidder_proposals.unit_price).
      as(proposal_total) }.first.proposal_total

    BigDecimal.new(total || 0)
  end
end
