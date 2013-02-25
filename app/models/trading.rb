class Trading < Compras::Model
  attr_accessible :code, :entity_id, :licitating_unit_id, :trading_registry,
                  :year, :licitation_process_id, :items_attributes,
                  :licitation_commission_id, :preamble, :closing_of_accreditation

  auto_increment :code, :by => :year

  belongs_to :entity
  belongs_to :licitation_commission
  belongs_to :licitation_process
  belongs_to :licitating_unit, :class_name => "Entity",
                               :foreign_key => "licitating_unit_id"

  has_many :items, :dependent => :destroy, :class_name => 'TradingItem'
  has_many :bidders, :through => :licitation_process, :order => :id
  has_many :closings, :dependent => :destroy, :class_name => 'TradingClosing', :order => "id DESC"

  accepts_nested_attributes_for :items

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

  orderize "year DESC, code DESC"
  filterize

  def to_s
    code_and_year
  end

  def code_and_year
    "#{code}/#{year}"
  end

  def current_closing
    closings.first
  end

  def allow_closing?
    items.not_closed.empty?
  end

  private

  def modality_type
    return unless licitation_process.present?

    unless licitation_process.administrative_process_trading?
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
