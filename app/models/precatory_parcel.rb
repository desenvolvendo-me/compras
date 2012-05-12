class PrecatoryParcel < ActiveRecord::Base
  attr_accessible :expiration_date, :value, :situation, :payment_date
  attr_accessible :amount_paid, :observation

  has_enumeration_for :situation, :with => PrecatoryParcelSituation

  belongs_to :precatory

  validates :expiration_date, :value, :situation, :presence => true
end
