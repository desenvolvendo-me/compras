class Descriptor < Compras::Model
  attr_accessible :period, :entity_id

  attr_modal :entity, :year

  belongs_to :entity

  has_many :budget_allocations, :dependent => :restrict
  has_many :expense_natures, :dependent => :restrict
  has_many :government_actions, :dependent => :restrict
  has_many :management_units, :dependent => :restrict
  has_many :pledges, :dependent => :restrict
  has_many :reserve_funds, :dependent => :restrict
  has_many :subfunctions, :dependent => :restrict

  validates :entity_id, :uniqueness => { :scope => [:period], :message => :taken_for_informed_period }, :allow_blank => true

  validates :period, :entity, :presence => true

  localize :period, :using => MonthAndYearParser

  orderize :period

  def self.filter(options)
    query = scoped
    query = query.where { entity_id.eq(options[:entity_id]) } if options[:entity_id].present?
    query = query.by_year(options[:year].to_i) if options[:year]
    query
  end

  def self.by_year(value)
    date = Date.new(value)
    date_range = date..(date.end_of_year)

    where { period.in(date_range) }
  end

  def to_s
    "#{year} - #{entity}"
  end

  def year
    period.try(:year)
  end

  def month
    period.try(:month)
  end
end
