class PledgeCancellation < ActiveRecord::Base
  attr_accessible :pledge_id, :date, :kind, :reason, :value_canceled, :nature
  attr_accessible :pledge_expiration_id

  has_enumeration_for :kind, :with => PledgeCancellationKind, :create_helpers => true
  has_enumeration_for :nature, :with => PledgeCancellationNature

  belongs_to :pledge
  belongs_to :pledge_expiration

  delegate :emission_date, :to => :pledge, :allow_nil => true
  delegate :value, :to => :pledge, :prefix => true, :allow_nil => true
  delegate :expiration_date, :to => :pledge_expiration, :allow_nil => true
  delegate :value, :to => :pledge_expiration, :prefix => true, :allow_nil => true

  validates :pledge, :date, :kind, :reason, :presence => true
  validates :date, :timeliness => {
    :on_or_after => lambda { last.date },
    :on_or_after_message => :must_be_greather_or_equal_to_last_date,
    :type => :date
  }, :allow_blank => true, :if => :any_pledge_cancellation?
  validate :validate_value_canceled
  validate :date_must_be_greater_than_expiration_date

  before_save :force_canceled_value_to_total_kind

  orderize :id
  filterize

  def to_s
    "#{id}"
  end

  protected

  def date_must_be_greater_than_expiration_date
    return if expiration_date.blank? || date.blank?

    errors.add(:date, :must_be_greater_than_pledge_emission_date) if date < expiration_date
  end

  def any_pledge_cancellation?
    self.class.any?
  end

  def force_canceled_value_to_total_kind
    canceled_value = pledge_expiration.value if pledge_expiration.present? && total?
  end

  def validate_value_canceled
    return if pledge_expiration.blank? || value_canceled.blank?

    if (pledge_expiration.pledge_cancellations.sum(&:value) + value_canceled) > pledge_expiration.value
      errors.add(:value_canceled, :must_not_be_greater_than_pledge_expiration_cancellations_sum_or_pledge_expiration_value)
    end
  end
end
