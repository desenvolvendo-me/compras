class Descriptor < Compras::Model
  attr_accessible :year, :entity_id

  belongs_to :entity

  has_many :budget_allocations, :dependent => :restrict
  has_many :capabilities, :dependent => :restrict
  has_many :expense_natures, :dependent => :restrict
  has_many :extra_credits, :dependent => :restrict
  has_many :government_actions, :dependent => :restrict
  has_many :government_programs, :dependent => :restrict
  has_many :management_units, :dependent => :restrict
  has_many :pledge_historics, :dependent => :restrict
  has_many :pledges, :dependent => :restrict
  has_many :reserve_funds, :dependent => :restrict
  has_many :budget_revenue, :dependent => :restrict
  has_many :revenue_natures, :dependent => :restrict
  has_many :subfunctions, :dependent => :restrict

  validates :year, :entity, :presence => true
  validates :year, :mask => '9999', :allow_blank => true
  validates :entity_id, :uniqueness => { :scope => [:year], :message => :taken_for_informed_year }, :allow_blank => true

  orderize :year
  filterize

  def to_s
    "#{year} - #{entity}"
  end
end
