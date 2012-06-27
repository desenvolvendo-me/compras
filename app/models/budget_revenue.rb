class BudgetRevenue < Compras::Model
  attr_accessible :descriptor_id, :revenue_nature_id, :capability_id, :code
  attr_accessible :kind, :value

  has_enumeration_for :kind, :with => BudgetRevenueKind, :create_helpers => true

  belongs_to :descriptor
  belongs_to :revenue_nature
  belongs_to :capability

  delegate :docket, :to => :revenue_nature, :allow_nil => true, :prefix => true
  delegate :year, :to => :descriptor, :allow_nil => true

  validates :descriptor, :revenue_nature, :capability, :presence => true
  validates :kind, :presence => true
  validates :value, :presence => true, :if => :divide?
  validates :revenue_nature_id, :uniqueness => true, :allow_blank => true
  validates :code, :uniqueness => { :scope => [:descriptor_id] }, :allow_blank => true

  before_create :set_code

  orderize :code
  filterize

  def to_s
    "#{code}/#{year}"
  end

  private

  def set_code
    self.code = last_code.succ
  end

  def last_code
    self.class.where { |budget_revenue|
      budget_revenue.descriptor_id.eq(descriptor_id)
    }.maximum(:code).to_i
  end
end
