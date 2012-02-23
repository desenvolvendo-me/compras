class FoundedDebtContract < ActiveRecord::Base
  attr_accessible :year, :entity_id, :contract_number, :process_number
  attr_accessible :signed_date, :end_date, :description

  belongs_to :entity

  orderize :year
  filterize

  validates :entity, :contract_number, :process_number, :presence => true
  validates :signed_date, :end_date, :description, :presence => true
  validates :year, :presence => true, :mask => '9999'

  def to_s
    "#{id}/#{year}"
  end
end
