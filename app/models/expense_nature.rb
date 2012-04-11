class ExpenseNature < ActiveRecord::Base
  attr_accessible :entity_id, :regulatory_act_id
  attr_accessible :expense_element, :kind, :expense_group_id
  attr_accessible :description, :docket, :expense_category_id

  attr_modal :expense_element, :description, :entity_id
  attr_modal :regulatory_act_id, :kind

  has_enumeration_for :kind, :with => ExpenseNatureKind, :create_helpers => true

  belongs_to :entity
  belongs_to :regulatory_act
  belongs_to :expense_category
  belongs_to :expense_group

  has_many :purchase_solicitation_budget_allocations, :dependent => :restrict
  has_many :materials, :dependent => :restrict
  has_many :budget_allocations, :dependent => :restrict

  validates :expense_element, :kind, :description, :expense_group, :presence => true
  validates :expense_element, :mask => '9.9.99.99.99.99.99.99', :allow_blank => true

  orderize :description
  filterize

  def to_s
    expense_element
  end
end
