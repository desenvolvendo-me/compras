class PledgeLiquidation < ActiveRecord::Base
  attr_accessible :pledge_id, :pledge_expiration_id, :kind, :value, :date

  has_enumeration_for :kind, :with => PledgeLiquidationKind, :create_helpers => true

  belongs_to :pledge
  belongs_to :pledge_expiration

  delegate :emission_date, :description, :to => :pledge, :allow_nil => true
  delegate :value, :to => :pledge, :prefix => true, :allow_nil => true
  delegate :balance, :expiration_date, :to => :pledge_expiration, :allow_nil => true

  validates :pledge, :pledge_expiration, :kind, :value, :presence => true
  validates :date, :presence => true
  validates :date, :timeliness => {
    :on_or_after => lambda { last.date },
    :on_or_after_message => :must_be_greater_or_equal_to_last_pledge_liquidation_date,
    :type => :date,
    :on => :create,
    :allow_blank => true,
    :if => :any_pledge_liquidation?
  }
  validate :date_must_be_greater_than_emission_date
  validate :validate_value

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

  def any_pledge_liquidation?
    self.class.any?
  end

  def date_must_be_greater_than_emission_date
    return unless emission_date && date

    if date < emission_date
      errors.add(:date, :must_be_greater_than_pledge_emission_date)
    end
  end

  def validate_value
    return if pledge_expiration.blank? || value.blank?

    if value > balance
      errors.add(:value, :must_not_be_greater_than_pledge_expiration_balance)
    end
  end
end
