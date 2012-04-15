class BudgetUnit < ActiveRecord::Base
  attr_accessible :description, :organogram, :tce_code, :acronym
  attr_accessible :performance_field, :budget_unit_configuration_id
  attr_accessible :administration_type_id, :address_attributes
  attr_accessible :budget_unit_responsibles_attributes, :kind

  has_enumeration_for :kind, :with => BudgetUnitKind, :create_helpers => true

  belongs_to :budget_unit_configuration
  belongs_to :administration_type

  has_one :address, :as => :addressable, :dependent => :destroy

  has_many :budget_allocations, :dependent => :restrict
  has_many :purchase_solicitations, :dependent => :restrict
  has_many :budget_unit_responsibles, :dependent => :destroy, :order => :id
  has_many :direct_purchases, :dependent => :restrict
  has_many :administrative_processes, :dependent => :restrict

  delegate :mask, :to => :budget_unit_configuration, :allow_nil => true

  validates :description, :organogram, :tce_code, :acronym, :presence => true
  validates :performance_field, :budget_unit_configuration, :presence => true
  validates :administration_type, :kind, :presence => true
  validates :organogram, :mask => :mask, :allow_blank => true
  validate :cannot_have_duplicated_responsibles

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :budget_unit_responsibles, :allow_destroy => true

  orderize :description
  filterize

  def to_s
    "#{organogram} - #{description}"
  end

  protected

  def cannot_have_duplicated_responsibles
    single_responsibles = []

    budget_unit_responsibles.each do |budget_unit_responsible|
      if single_responsibles.include?(budget_unit_responsible.responsible_id)
        errors.add(:budget_unit_responsibles)
        budget_unit_responsible.errors.add(:responsible_id, :taken)
      end
      single_responsibles << budget_unit_responsible.responsible_id
    end
  end
end
