class PledgeCancellation < Compras::Model
  attr_accessible :pledge_id, :date, :reason, :value, :nature

  has_enumeration_for :nature, :with => PledgeCancellationNature

  belongs_to :pledge

  delegate :balance, :value, :to => :pledge, :prefix => true, :allow_nil => true
  delegate :emission_date, :pledge_cancellations_sum, :pledge_liquidations_sum,
           :to => :pledge, :allow_nil => true

  validates :pledge, :date, :reason, :presence => true
  validates :value, :presence => true, :numericality => { :greater_than => 0 }
  validates :date, :timeliness => {
    :on_or_after => lambda { last.date },
    :on_or_after_message => :must_be_greater_or_equal_to_last_pledge_cancellation_date,
    :type => :date,
    :on => :create,
    :allow_blank => true,
    :if => :any_pledge_cancellation?
  }
  validate :value_validation
  validate :date_must_be_equal_or_greater_than_pledge_emission_date

  orderize :id
  filterize

  def to_s
    id.to_s
  end

  protected

  def date_must_be_equal_or_greater_than_pledge_emission_date
    return if emission_date.blank? || date.blank?

    if date < emission_date
      errors.add(:date, :must_be_equal_or_greater_than_pledge_emission_date)
    end
  end

  def any_pledge_cancellation?
    self.class.any?
  end

  def value_validation
    return unless pledge && value

    if value > pledge_balance
      errors.add(:value, :must_not_be_greater_than_pledge_balance)
    end
  end
end
