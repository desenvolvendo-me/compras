class PledgeCancellation < ActiveRecord::Base
  attr_accessible :pledge_id, :date, :kind, :reason, :value_canceled, :nature
  attr_accessible :pledge_expiration_id

  has_enumeration_for :kind, :with => PledgeCancellationKind
  has_enumeration_for :nature, :with => PledgeCancellationNature

  belongs_to :pledge
  belongs_to :pledge_expiration

  delegate :emission_date, :to => :pledge, :allow_nil => true
  delegate :value, :to => :pledge, :prefix => true, :allow_nil => true
  delegate :expiration_date, :to => :pledge_expiration, :allow_nil => true
  delegate :value, :to => :pledge_expiration, :prefix => true, :allow_nil => true

  validates :pledge, :date, :kind, :reason, :presence => true
  validate :validate_value_canceled

  orderize :id
  filterize

  def to_s
    "#{id}"
  end

  protected

  def validate_value_canceled
    return if pledge_expiration.blank? || value_canceled.blank?

    if (pledge_expiration.pledge_cancellations.sum(&:value) + value_canceled) > pledge_expiration.value
      errors.add(:value_canceled, :must_not_be_greater_than_pledge_expiration_cancellations_sum_or_pledge_expiration_value)
    end
  end
end
