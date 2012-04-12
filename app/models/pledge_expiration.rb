class PledgeExpiration < ActiveRecord::Base
  attr_accessible :expiration_date, :value, :number, :pledge_id

  belongs_to :pledge

  has_many :pledge_cancellations, :dependent => :restrict

  delegate :emission_date, :to => :pledge, :allow_nil => true
  delegate :value, :to => :pledge, :prefix => true, :allow_nil => true

  validates :expiration_date, :value, :presence => true

  orderize :id
  filterize

  def canceled_value
    pledge_cancellations.compact.sum(&:value)
  end

  def to_s
    "#{number}"
  end
end
