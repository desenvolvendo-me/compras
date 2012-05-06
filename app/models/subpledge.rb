class Subpledge < ActiveRecord::Base
  attr_accessible :entity_id, :pledge_id, :creditor_id, :year, :number, :date
  attr_accessible :value, :process_number, :description
  attr_accessible :subpledge_expirations_attributes

  belongs_to :entity
  belongs_to :pledge
  belongs_to :creditor

  has_many :subpledge_expirations, :dependent => :destroy

  accepts_nested_attributes_for :subpledge_expirations, :allow_destroy => true

  delegate :emission_date, :balance, :to => :pledge, :allow_nil => true
  delegate :last_subpledge, :to => :pledge, :allow_nil => true
  delegate :value, :creditor, :to => :pledge, :allow_nil => true, :prefix => true

  validates :entity, :year, :pledge, :creditor, :date, :presence => true
  validates :value, :process_number, :description, :presence => true
  validates :year, :mask => '9999', :allow_blank => true
  validates :date, :timeliness => {
    :on_or_after => lambda { last.date },
    :on_or_after_message => :must_be_greater_or_equal_to_last_subpledge_date,
    :type => :date,
    :on => :create,
    :allow_blank => true,
    :if => :any_subpledge?
  }
  validate :date_must_be_greater_than_emission_date
  validate :value_validation
  validate :only_accept_pledge_global_or_estimated
  validate :subpledge_expirations_value_sum_should_be_equals_value
  validate :validate_subpledge_expirations_expiration_date

  orderize :id
  filterize

  def to_s
    id.to_s
  end

  def pledge_parcels
    return [] if pledge.blank?

    pledge.pledge_parcels
  end

  def next_number
    last_number.succ
  end

  protected

  def last_number
    return 0 unless last_subpledge

    last_subpledge.number
  end

  def first_pledge_parcel_available
    pledge_parcels.each do |expiration|
      if expiration.balance > 0
        return expiration
      end
    end

    return
  end

  def validate_subpledge_expirations_expiration_date
    return unless pledge && first_pledge_parcel_available

    subpledge_expirations.each do |expiration|
      if expiration.expiration_date < first_pledge_parcel_available.expiration_date
        expiration.errors.add(:expiration_date, :must_not_be_greater_to_first_pledge_parcel_avaliable, :restriction => I18n.l(first_pledge_parcel_available.expiration_date))
      end
    end
  end

  def subpledge_expirations_value_sum_should_be_equals_value
    return unless value

    if subpledge_expirations.map(&:value).compact.sum > value
      subpledge_expirations.each do |expiration|
        expiration.errors.add(:value, :subpledge_expiration_value_sum_must_not_be_greater_to_subpledge_value)
      end

      errors.add(:pledge_parcels, :invalid)
    end
  end

  def only_accept_pledge_global_or_estimated
    return unless pledge

    unless pledge.global? || pledge.estimated?
      errors.add(:pledge, :must_be_pledge_global_or_estimated)
    end
  end

  def any_subpledge?
    self.class.any?
  end

  def date_must_be_greater_than_emission_date
    return unless emission_date && date

    if date < emission_date
      errors.add(:date, :must_be_greater_than_pledge_emission_date)
    end
  end

  def value_validation
    return unless pledge && value

    if value > balance
      errors.add(:value, :must_not_be_greater_than_pledge_balance)
    end
  end
end
