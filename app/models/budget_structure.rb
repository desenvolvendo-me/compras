class BudgetStructure < ActiveRecord::Base
  attr_accessible :description, :budget_structure, :tce_code, :acronym
  attr_accessible :performance_field, :budget_structure_configuration_id
  attr_accessible :administration_type_id, :address_attributes
  attr_accessible :budget_structure_responsibles_attributes, :kind

  has_enumeration_for :kind, :with => BudgetStructureKind, :create_helpers => true

  belongs_to :budget_structure_configuration
  belongs_to :administration_type

  has_one :address, :as => :addressable, :dependent => :destroy

  has_many :budget_allocations, :dependent => :restrict
  has_many :purchase_solicitations, :dependent => :restrict
  has_many :budget_structure_responsibles, :dependent => :destroy, :order => :id
  has_many :direct_purchases, :dependent => :restrict

  delegate :mask, :to => :budget_structure_configuration, :allow_nil => true

  validates :description, :budget_structure, :tce_code, :acronym, :presence => true
  validates :performance_field, :budget_structure_configuration, :presence => true
  validates :administration_type, :kind, :presence => true
  validates :budget_structure, :mask => :mask, :allow_blank => true
  validate :cannot_have_duplicated_responsibles

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :budget_structure_responsibles, :allow_destroy => true

  orderize :description
  filterize

  def to_s
    "#{budget_structure} - #{description}"
  end

  protected

  def cannot_have_duplicated_responsibles
    single_responsibles = []

    budget_structure_responsibles.each do |budget_structure_responsible|
      if single_responsibles.include?(budget_structure_responsible.responsible_id)
        errors.add(:budget_structure_responsibles)
        budget_structure_responsible.errors.add(:responsible_id, :taken)
      end
      single_responsibles << budget_structure_responsible.responsible_id
    end
  end
end
