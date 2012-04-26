class PledgeLiquidationCancellation < ActiveRecord::Base
  attr_accessible :pledge_id, :pledge_expiration_id, :kind, :value, :date, :reason

  has_enumeration_for :kind, :with => PledgeLiquidationCancellationKind, :create_helpers => true

  belongs_to :pledge
  belongs_to :pledge_expiration

  delegate :liquidations_value, :balance, :expiration_date, :to => :pledge_expiration, :allow_nil => true
  delegate :emission_date, :to => :pledge, :allow_nil => true
  delegate :value, :to => :pledge, :prefix => true, :allow_nil => true

  validates :pledge, :pledge_expiration, :date, :kind, :reason, :value, :presence => true
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
    if pledge_expiration.present? && total?
      self.value = pledge_expiration.value
    end
  end

  def date_must_be_greater_than_emission_date
    return if emission_date.blank? || date.blank?

    if date < emission_date
      errors.add(:date, :must_be_greater_than_pledge_emission_date)
    end
  end

  def value_validation
    return unless pledge_expiration

    if value > liquidations_value
      errors.add(:value, :must_not_be_greater_than_pledge_expiration_liquidations)
    end
  end

  def any_pledge_cancellation?
    self.class.any?
  end
end
