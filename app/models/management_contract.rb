class ManagementContract < ActiveRecord::Base
  attr_accessible :year, :entity_id, :contract_number, :process_number
  attr_accessible :signature_date, :end_date, :description

  belongs_to :entity

  has_many :pledges, :dependent => :restrict

  validates :year, :entity, :contract_number, :process_number, :presence => true
  validates :signature_date, :end_date, :description, :presence => true
  validates :year, :mask => "9999", :allow_blank => true

  orderize :contract_number
  filterize

  def to_s
    "#{id}/#{year}"
  end
end
