class PledgeExpiration < ActiveRecord::Base
  attr_accessible :expiration_date, :value, :number, :pledge_id

  belongs_to :pledge

  has_many :pledge_cancellations, :dependent => :restrict
  has_many :pledge_liquidations, :dependent => :restrict

  delegate :emission_date, :to => :pledge, :allow_nil => true
  delegate :value, :to => :pledge, :prefix => true, :allow_nil => true

  validates :expiration_date, :value, :presence => true

  orderize :id
  filterize

  def canceled_value
    pledge_cancellations.sum(:value)
  end

  def liquidations_value
    pledge_liquidations.sum(:value)
  end

  def balance
    value - canceled_value - liquidations_value
  end

  def to_s
    "#{number}"
  end
end
