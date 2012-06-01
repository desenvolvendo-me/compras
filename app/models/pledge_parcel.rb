class PledgeParcel < ActiveRecord::Base
  attr_accessible :expiration_date, :value, :number, :pledge_id

  belongs_to :pledge

  has_many :pledge_parcel_movimentations, :dependent => :restrict

  delegate :emission_date, :to => :pledge, :allow_nil => true
  delegate :value, :description, :to => :pledge, :prefix => true, :allow_nil => true

  validates :expiration_date, :value, :presence => true

  orderize :id
  filterize

  def canceled_value
    pledge_parcel_movimentations.where { pledge_parcel_modifiable_type.eq 'PledgeCancellation' }.sum(:value)
  end

  def liquidations_value
    pledge_parcel_movimentations.where { pledge_parcel_modifiable_type.eq 'PledgeLiquidation' }.sum(:value)
  end

  def canceled_liquidations_value
    pledge_parcel_movimentations.where { pledge_parcel_modifiable_type.eq 'PledgeLiquidationCancellation' }.sum(:value)
  end

  def subpledges_sum
    pledge_parcel_movimentations.where { pledge_parcel_modifiable_type.eq 'Subpledge' }.sum(:value)
  end

  def balance
    value - canceled_value - liquidations_value + canceled_liquidations_value - subpledges_sum
  end

  def cancellation_moviments
    canceled_value + liquidations_value
  end

  def to_s
    "#{number}"
  end
end
