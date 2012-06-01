class PledgeLiquidationCancellation < ActiveRecord::Base
  attr_accessible :pledge_id, :value, :date, :reason

  belongs_to :pledge

  delegate :emission_date, :to => :pledge, :allow_nil => true
  delegate :value, :balance, :to => :pledge, :prefix => true, :allow_nil => true
  delegate :liquidation_value, :to => :pledge, :prefix => true, :allow_nil => true
  delegate :pledge_liquidations_sum, :to => :pledge, :allow_nil => true
  delegate :pledge_liquidation_cancellations_sum, :to => :pledge, :allow_nil => true

  validates :pledge, :date, :reason, :presence => true
  validates :value, :presence => true, :numericality => { :greater_than => 0 }
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

  orderize :id
  filterize

  def movimentable_pledge_parcels
    return unless pledge

    pledge.pledge_parcels_with_liquidations
  end

  def to_s
    id.to_s
  end

  protected

  def date_must_be_greater_than_emission_date
    return unless pledge && date

    if date < emission_date
      errors.add(:date, :must_be_greater_than_pledge_emission_date)
    end
  end

  def value_validation(numeric_parser = ::I18n::Alchemy::NumericParser)
    return unless pledge && value

    if value > pledge_liquidation_value
      errors.add(:value, :must_not_be_greater_than_pledge_liquidation_value, :value => numeric_parser.localize(pledge_liquidation_value))
    end
  end

  def any_pledge_cancellation?
    self.class.any?
  end
end
