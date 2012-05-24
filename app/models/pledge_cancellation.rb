class PledgeCancellation < ActiveRecord::Base
  attr_accessible :pledge_id, :date, :kind, :reason, :value, :nature
  attr_accessible :entity_id, :year

  has_enumeration_for :kind, :with => PledgeCancellationKind, :create_helpers => true
  has_enumeration_for :nature, :with => PledgeCancellationNature

  belongs_to :entity
  belongs_to :pledge

  has_many :pledge_parcel_modifications, :dependent => :restrict, :as => :pledge_parcel_modificator

  delegate :emission_date, :to => :pledge, :allow_nil => true
  delegate :balance, :to => :pledge, :prefix => true, :allow_nil => true

  validates :pledge, :date, :kind, :reason, :value, :entity, :presence => true
  validates :year, :presence => true
  validates :year, :mask => '9999', :allow_blank => true
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

  before_validation :force_value_to_total_kind

  orderize :id
  filterize

  def movimentable_pledge_parcels
    return unless pledge

    pledge.pledge_parcels_with_balance
  end

  def to_s
    "#{id}"
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

  def force_value_to_total_kind
    return unless pledge

    if total?
      self.value = pledge_balance
    end
  end

  def value_validation
    return unless pledge && value

    if value > pledge_balance
      errors.add(:value, :must_not_be_greater_than_pledge_balance)
    end
  end
end
