class ExpenseElement < ActiveRecord::Base
  attr_accessible :entity_id, :regulatory_act_id
  attr_accessible :expense_element, :kind
  attr_accessible :description, :docket

  attr_modal :expense_element, :description, :entity_id
  attr_modal :regulatory_act_id, :kind

  has_enumeration_for :kind, :with => ExpenseElementKind, :create_helpers => true

  belongs_to :entity
  belongs_to :regulatory_act

  has_many :purchase_solicitations, :dependent => :restrict
  has_many :purchase_solicitation_budget_allocations, :dependent => :restrict
  has_many :materials, :dependent => :restrict
  has_many :budget_allocations, :dependent => :restrict

  validates :expense_element, :kind, :description, :presence => true
  validates :expense_element, :mask => '9.9.99.99.99.99.99.99'

  orderize :description
  filterize

  def to_s
    expense_element
  end
end
