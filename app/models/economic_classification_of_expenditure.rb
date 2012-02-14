class EconomicClassificationOfExpenditure < ActiveRecord::Base
  attr_accessible :entity_id, :administractive_act_id
  attr_accessible :economic_classification_of_expenditure, :kind
  attr_accessible :description, :docket, :stn_ordinance_id

  attr_modal :kind, :description, :stn_ordinance_id, :economic_classification_of_expenditure

  has_enumeration_for :kind, :with => EconomicClassificationOfExpenditureKind, :create_helpers => true

  belongs_to :entity
  belongs_to :administractive_act
  belongs_to :stn_ordinance
  has_many :purchase_solicitations, :dependent => :restrict
  has_many :purchase_solicitation_budget_allocations, :dependent => :restrict
  has_many :materials, :dependent => :restrict

  validates :economic_classification_of_expenditure, :kind, :description, :presence => true
  validates :economic_classification_of_expenditure, :mask => '9.9.99.99.99.99.99.99'
  validates :stn_ordinance_id, :presence => true

  orderize :description
  filterize

  def to_s
    economic_classification_of_expenditure
  end
end
