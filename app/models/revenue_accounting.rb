class RevenueAccounting < Compras::Model
  attr_accessible :entity_id, :revenue_nature_id, :capability_id, :code, :year
  attr_accessible :kind, :value

  has_enumeration_for :kind, :with => RevenueAccountingKind, :create_helpers => true

  belongs_to :entity
  belongs_to :revenue_nature
  belongs_to :capability

  delegate :docket, :to => :revenue_nature, :allow_nil => true, :prefix => true

  validates :entity, :year, :revenue_nature, :capability, :presence => true
  validates :kind, :presence => true
  validates :value, :presence => true, :if => :divide?
  validates :year, :mask => '9999', :allow_blank => true
  validates :revenue_nature_id, :uniqueness => true, :allow_blank => true
  validates :code, :uniqueness => { :scope => [:entity_id, :year] }

  orderize :code
  filterize

  def to_s
    code
  end

  def next_code
    last_code.succ
  end

  private

  def last_code
    self.class.where { self.year.eq(year) & self.entity_id.eq(entity_id) }.maximum(:code).to_i
  end
end
