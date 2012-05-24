class PledgeLiquidation < ActiveRecord::Base
  attr_accessible :pledge_id, :kind, :value, :date
  attr_accessible :entity_id, :year

  has_enumeration_for :kind, :with => PledgeLiquidationKind, :create_helpers => true

  belongs_to :pledge
  belongs_to :entity

  has_many :pledge_parcel_movimentations, :dependent => :restrict, :as => :pledge_parcel_modificator

  delegate :emission_date, :description, :to => :pledge, :allow_nil => true
  delegate :value, :balance, :to => :pledge, :prefix => true, :allow_nil => true

  validates :pledge, :kind, :value, :presence => true
  validates :date, :entity, :year, :presence => true
  validate :date_must_be_greater_than_emission_date
  validate :validate_value

  with_options :allow_blank => true do |allowing_blank|
    allowing_blank.validates :year, :mask => '9999'
    allowing_blank.validates :date, :timeliness => {
      :on_or_after => lambda { last.date },
      :on_or_after_message => :must_be_greater_or_equal_to_last_pledge_liquidation_date,
      :type => :date,
      :on => :create,
      :if => :any_pledge_liquidation?
    }
  end

  before_validation :force_value_to_total_kind

  orderize :id
  filterize

  def movimentable_pledge_parcels
    return unless pledge

    pledge.pledge_parcels_with_balance
  end

  def to_s
    id.to_s
  end

  protected

  def force_value_to_total_kind
    if pledge && total?
      self.value = pledge_balance
    end
  end

  def any_pledge_liquidation?
    self.class.any?
  end

  def date_must_be_greater_than_emission_date
    return unless pledge && date

    if date < emission_date
      errors.add(:date, :must_be_greater_than_pledge_emission_date)
    end
  end

  def validate_value
    return unless pledge && value

    if value > pledge_balance
      errors.add(:value, :must_not_be_greater_than_pledge_balance)
    end
  end
end
