class Subpledge < ActiveRecord::Base
  attr_accessible :entity_id, :pledge_id, :creditor_id, :year, :number, :date
  attr_accessible :value, :process_number, :description

  belongs_to :entity
  belongs_to :pledge
  belongs_to :creditor

  delegate :emission_date, :balance, :to => :pledge, :allow_nil => true
  delegate :value, :creditor, :to => :pledge, :allow_nil => true, :prefix => true

  validates :entity, :year, :pledge, :creditor, :date, :presence => true
  validates :value, :process_number, :description, :presence => true
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

  def only_accept_pledge_global_or_estimated
    return unless pledge

    unless pledge.global? || pledge.estimated?
      errors.add(:pledge, :must_be_pledge_global_or_estimated)
    end
  end

  orderize :id
  filterize

  def to_s
    id.to_s
  end

  def next_number
    next_number = self.class.where { |subpledge| subpledge.pledge_id.eq(subpledge.pledge_id) }.count

    next_number.succ
  end

  protected

  def any_subpledge?
    self.class.any?
  end

  def date_must_be_greater_than_emission_date
    return if emission_date.blank? || date.blank?

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
