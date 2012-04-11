class ExpenseNature < ActiveRecord::Base
  attr_accessible :entity_id, :regulatory_act_id
  attr_accessible :classification, :kind, :expense_group_id
  attr_accessible :description, :docket, :expense_category_id
  attr_accessible :expense_modality_id

  attr_modal :classification, :description, :entity_id
  attr_modal :regulatory_act_id, :kind

  has_enumeration_for :kind, :with => ExpenseNatureKind, :create_helpers => true

  belongs_to :entity
  belongs_to :regulatory_act
  belongs_to :expense_category
  belongs_to :expense_group
  belongs_to :expense_modality

  has_many :purchase_solicitation_budget_allocations, :dependent => :restrict
  has_many :materials, :dependent => :restrict
  has_many :budget_allocations, :dependent => :restrict

  validates :classification, :kind, :description, :expense_group, :presence => true
  validates :expense_modality, :presence => true
  validates :classification, :mask => '9.9.99.99.99.99.99.99', :allow_blank => true

  orderize :description
  filterize

  def to_s
    classification
  end
end
