class PledgeLiquidationCancellation < ActiveRecord::Base
  attr_accessible :pledge_id, :kind, :value, :date
  attr_accessible :reason, :entity_id, :year

  has_enumeration_for :kind, :with => PledgeLiquidationCancellationKind, :create_helpers => true

  belongs_to :entity
  belongs_to :pledge

  delegate :emission_date, :pledge_liquidations_sum, :to => :pledge, :allow_nil => true
  delegate :value, :balance, :to => :pledge, :prefix => true, :allow_nil => true

  validates :pledge, :date, :kind, :reason, :presence => true
  validates :value, :entity, :year, :presence => true
  validates :year, :mask => '9999', :allow_blank => true
  validates :date, :timeliness => {
    :on_or_after => lambda { last.date },
    :on_or_after_message => :must_be_greater_or_equal_to_last_pledge_liquidation_cancellation_date,
    :type => :date,
    :on => :create,
    :allow_blank => true,
    :if => :any_pledge_cancellation?
  }
  validate :value_validation
  validate :date_must_be_greater_than_emission_date

  before_validation :force_value_to_total_kind

  orderize :id
  filterize

  def to_s
    id.to_s
  end

  protected

  def force_value_to_total_kind
    if pledge && total?
      self.value = pledge_liquidations_sum
    end
  end

  def date_must_be_greater_than_emission_date
    return unless pledge && date

    if date < emission_date
      errors.add(:date, :must_be_greater_than_pledge_emission_date)
    end
  end

  def value_validation(numeric_parser = ::I18n::Alchemy::NumericParser)
    return unless pledge && value

    if value > pledge_liquidations_sum
      errors.add(:value, :must_not_be_greater_than_pledge_liquidations_value, :value => numeric_parser.localize(pledge_liquidations_sum))
    end
  end

  def any_pledge_cancellation?
    self.class.any?
  end
end
