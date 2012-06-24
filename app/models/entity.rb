class Entity < Compras::Model
  attr_accessible :name

  has_many :budget_structure_configurations, :dependent => :restrict
  has_many :contracts, :dependent => :restrict
  has_many :descriptors, :dependent => :restrict

  validates :name, :presence => true
  validates :name, :uniqueness => { :allow_blank => true }

  orderize
  filterize

  def to_s
    name
  end
end
