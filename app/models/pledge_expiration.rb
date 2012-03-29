class PledgeExpiration < ActiveRecord::Base
  attr_accessible :expiration_date, :value, :number

  attr_accessor :order

  belongs_to :pledge

  validates :expiration_date, :value, :presence => true

  def to_s
    "#{number}"
  end
end
