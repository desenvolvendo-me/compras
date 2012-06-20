class ExpenseNature < Compras::Model
  attr_accessible :entity_id, :regulatory_act_id, :expense_split
  attr_accessible :expense_nature, :kind, :expense_group_id
  attr_accessible :description, :docket, :expense_category_id
  attr_accessible :expense_modality_id, :expense_element_id, :year

  has_enumeration_for :kind, :with => ExpenseNatureKind, :create_helpers => true

  belongs_to :entity
  belongs_to :regulatory_act
  belongs_to :expense_category
  belongs_to :expense_group
  belongs_to :expense_modality
  belongs_to :expense_element

  has_many :purchase_solicitation_budget_allocations, :dependent => :restrict
  has_many :materials, :dependent => :restrict
  has_many :budget_allocations, :dependent => :restrict
  has_many :pledges, :dependent => :restrict

  delegate :code, :to => :expense_category, :prefix => true, :allow_nil => true
  delegate :code, :to => :expense_group, :prefix => true, :allow_nil => true
  delegate :code, :to => :expense_modality, :prefix => true, :allow_nil => true
  delegate :code, :to => :expense_element, :prefix => true, :allow_nil => true

  validates :expense_nature, :kind, :description, :expense_group, :presence => true
  validates :expense_modality, :expense_element, :expense_split, :presence => true
  validates :expense_split, :mask => '99', :allow_blank => true
  validates :entity, :year, :regulatory_act, :expense_category, :presence => true

  orderize :description
  filterize

  def to_s
    "#{expense_nature} - #{description}"
  end
end
