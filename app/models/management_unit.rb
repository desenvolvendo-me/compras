class ManagementUnit < Compras::Model
  attr_accessible :descriptor_id, :description, :acronym, :status

  has_enumeration_for :status, :create_helpers => true

  belongs_to :descriptor

  has_many :pledges, :dependent => :restrict
  has_many :record_prices, :dependent => :restrict

  validates :descriptor, :description, :acronym, :status, :presence => true

  orderize :description
  filterize

  def to_s
    description
  end
end
