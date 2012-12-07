class Trading < Compras::Model
  attr_accessible :code, :entity_id, :licitating_unit_id,
                  :summarized_object, :year, :licitation_process_id,
                  :trading_items_attributes, :licitation_commission_id

  auto_increment :code, :by => :year

  belongs_to :entity
  belongs_to :licitation_commission
  belongs_to :licitation_process
  belongs_to :licitating_unit, :class_name => "Entity",
                               :foreign_key => "licitating_unit_id"

  has_many :trading_items, :dependent => :destroy
  has_many :bidders, :through => :licitation_process

  accepts_nested_attributes_for :trading_items

  validates :licitation_process, :year, :presence => true
  validates :licitation_process_id, :uniqueness => true
  validate :modality_type
  validate :licitation_commission_type
  validate :licitation_commission_expiration_date
  validate :licitation_commission_exoneration_date
  validate :licitation_process_with_published_edital

  delegate :auctioneer, :support_team, :licitation_commission_members,
           :to => :licitation_commission, :allow_nil => true
  delegate :administrative_process_summarized_object, :to => :licitation_process,
           :allow_nil => true
  delegate :items, :to => :licitation_process, :allow_nil => true,
           :prefix => true

  before_create :set_percentage_limit_to_participate_in_bids

  orderize :code
  filterize

  def to_s
    "#{code}/#{year}"
  end

  private

  def modality_type
    return unless licitation_process.present?

    unless licitation_process.presence_trading?
      errors.add(:licitation_process, :should_be_of_trading_type)
    end
  end

  def licitation_commission_type
    return unless licitation_commission.present?

    unless licitation_commission.trading?
      errors.add(:licitation_commission, :should_be_of_trading_type)
    end
  end

  def licitation_commission_expiration_date
    return unless licitation_commission.present?

    if licitation_commission.expired?
      errors.add(:licitation_commission, :should_not_be_expired)
    end
  end

  def licitation_commission_exoneration_date
    return unless licitation_commission.present?

    if licitation_commission.exonerated?
      errors.add(:licitation_commission, :should_not_be_exonerated)
    end
  end

  def set_percentage_limit_to_participate_in_bids
    self.percentage_limit_to_participate_in_bids = TradingConfiguration.percentage_limit_to_participate_in_bids
  end

  def licitation_process_with_published_edital
    return unless licitation_process.present?

    unless licitation_process.edital_published?
      errors.add(:licitation_process, :must_have_published_edital)
    end
  end
end
