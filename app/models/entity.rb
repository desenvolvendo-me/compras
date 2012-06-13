class Entity < Compras::Model
  attr_accessible :name

  has_many :expense_natures, :dependent => :restrict
  has_many :budget_structure_configurations, :dependent => :restrict
  has_many :capabilities, :dependent => :restrict
  has_many :government_programs, :dependent => :restrict
  has_many :government_actions, :dependent => :restrict
  has_many :pledge_historics, :dependent => :restrict
  has_many :budget_allocations, :dependent => :restrict
  has_many :pledges, :dependent => :restrict
  has_many :management_units, :dependent => :restrict
  has_many :reserve_funds, :dependent => :restrict
  has_many :contracts, :dependent => :restrict
  has_many :subfunctions, :dependent => :restrict
  has_many :extra_credits, :dependent => :restrict
  has_many :revenue_natures, :dependent => :restrict
  has_many :revenue_accountings, :dependent => :restrict

  validates :name, :presence => true
  validates :name, :uniqueness => { :allow_blank => true }

  orderize
  filterize

  def to_s
    name
  end
end
