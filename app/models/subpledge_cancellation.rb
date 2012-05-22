class SubpledgeCancellation < ActiveRecord::Base
  attr_accessible :entity_id, :pledge_id, :subpledge_id
  attr_accessible :year, :value, :date, :reason

  belongs_to :entity
  belongs_to :pledge
  belongs_to :subpledge

  delegate :value, :balance, :to => :subpledge, :allow_nil => true, :prefix => true
  delegate :provider, :emission_date, :to => :pledge, :allow_nil => true
  delegate :value, :to => :pledge, :prefix => true, :allow_nil => true
  delegate :subpledge_cancellations_sum, :to => :subpledge, :allow_nil => true

  validates :year, :pledge, :subpledge, :presence => true
  validates :entity, :value, :date, :reason, :presence => true
  validates :year, :mask => '9999', :allow_blank => true
  validate :pledge_must_has_subpledges
  validate :value_must_not_be_greater_than_subpledge_balance

  orderize :id
  filterize

  def to_s
    id.to_s
  end

  def movimentable_subpledge_expirations
    return unless subpledge

    subpledge.subpledge_expirations_with_balance
  end

  protected

  def pledge_must_has_subpledges
    return unless pledge

    unless pledge.subpledges?
      errors.add(:pledge, :pledge_must_has_subpledges)
    end
  end

  def value_must_not_be_greater_than_subpledge_balance
    return unless subpledge && value

    if value > subpledge_balance
      errors.add(:value, :must_not_be_greater_than_subpledge_balance)
    end
  end
end
