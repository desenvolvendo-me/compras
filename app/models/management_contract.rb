class ManagementContract < ActiveRecord::Base
  attr_accessible :year, :entity_id, :contract_number, :process_number, :signature_date, :end_date, :description

  orderize :contract_number
  filterize

  belongs_to :entity

  validates :year, :entity, :contract_number, :process_number, :signature_date, :end_date, :description, :presence => true
  validates :year, :mask => "9999"

  def to_s
    "#{id}/#{year}"
  end
end
