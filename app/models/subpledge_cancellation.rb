class SubpledgeCancellation < ActiveRecord::Base
  attr_accessible :entity_id, :pledge_id, :subpledge_id, :subpledge_expiration_id
  attr_accessible :year, :value, :date, :reason

  belongs_to :entity
  belongs_to :pledge
  belongs_to :subpledge
  belongs_to :subpledge_expiration

  delegate :balance, :to => :subpledge, :allow_nil => true, :prefix => true
  delegate :provider, :emission_date, :to => :pledge, :allow_nil => true
  delegate :value, :to => :pledge, :prefix => true, :allow_nil => true
  delegate :balance, :to => :subpledge_expiration, :allow_nil => true, :prefix => true

  validates :year, :pledge, :subpledge, :subpledge_expiration, :presence => true
  validates :entity, :value, :date, :reason, :presence => true
  validates :year, :mask => '9999', :allow_blank => true
  validate :pledge_must_has_subpledges
  validate :value_must_not_be_greater_than_subpledge_expiration_balance

  orderize :id
  filterize

  def to_s
    id.to_s
  end

  protected

  def pledge_must_has_subpledges
    return unless pledge

    unless pledge.subpledges?
      errors.add(:pledge, :pledge_must_has_subpledges)
    end
  end

  def value_must_not_be_greater_than_subpledge_expiration_balance
    return unless subpledge_expiration && value

    if value > subpledge_expiration_balance
      errors.add(:value, :must_not_be_greater_than_subpledge_expiration_balance)
    end
  end
end
