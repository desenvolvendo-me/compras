class ContractType < Compras::Model
  attr_accessible :description, :tce_code, :service_goal

  has_enumeration_for :service_goal, :create_helpers => true

  has_many :materials, :dependent => :restrict
  has_many :contracts, :dependent => :restrict

  validates :description, :tce_code, :service_goal, :presence => true
  validates :description, :uniqueness => { :allow_blank => true }

  filterize
  orderize :description

  def to_s
    description
  end
end
