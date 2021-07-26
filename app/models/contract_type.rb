class ContractType < Compras::Model
  attr_accessible :description, :tce_code, :service_goal

  has_enumeration_for :service_goal, :create_helpers => true

  has_many :contracts, :dependent => :restrict

  validates :description, :tce_code, :service_goal, :presence => true
  validates :description, :uniqueness => { :allow_blank => true }

  filterize
  orderize :description

  scope :term, lambda{|q|
    where{ description.like("#{q}%") }
  }


  def to_s
    description
  end
end
