class LicitationProcess < ActiveRecord::Base
  attr_accessible :bid_opening_id, :capability_id, :period_id, :payment_method_id, :year, :process_date
  attr_accessible :object_description, :expiration, :readjustment_index, :caution_value, :legal_advice
  attr_accessible :legal_advice_date, :contract_date, :contract_expiration, :observations

  has_enumeration_for :legal_advice, :with => LicitationProcessLegalAdvice

  belongs_to :bid_opening
  belongs_to :capability
  belongs_to :period
  belongs_to :payment_method

  validates :year,               :presence => true, :mask => "9999"
  validates :process_date,       :presence => true
  validates :bid_opening,        :presence => true
  validates :object_description, :presence => true
  validates :capability,         :presence => true
  validates :expiration,         :presence => true
  validates :readjustment_index, :presence => true
  validates :period,             :presence => true
  validates :payment_method,     :presence => true

  orderize :id
  filterize

  def to_s
    id.to_s
  end
end
