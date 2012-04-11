class ExpenseNature < ActiveRecord::Base
  attr_accessible :entity_id, :regulatory_act_id, :expense_split
  attr_accessible :full_code, :kind, :expense_group_id
  attr_accessible :description, :docket, :expense_category_id
  attr_accessible :expense_modality_id, :expense_element_id

  attr_modal :full_code, :description, :entity_id
  attr_modal :regulatory_act_id, :kind

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

  validates :full_code, :kind, :description, :expense_group, :presence => true
  validates :expense_modality, :expense_element, :expense_split, :presence => true
  validates :full_code, :mask => '9.9.99.99.99.99.99.99', :allow_blank => true
  validates :expense_split, :mask => '99999999', :allow_blank => true

  orderize :description
  filterize

  def to_s
    full_code
  end
end
