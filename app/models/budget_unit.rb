class BudgetUnit < ActiveRecord::Base
  attr_accessible :description, :organogram, :tce_code, :acronym
  attr_accessible :performance_field, :organogram_configuration_id
  attr_accessible :administration_type_id, :address_attributes
  attr_accessible :organogram_responsibles_attributes, :kind

  attr_modal :description

  has_enumeration_for :kind, :with => BudgetUnitKind, :create_helpers => true

  belongs_to :organogram_configuration
  belongs_to :administration_type

  has_one :address, :as => :addressable, :dependent => :destroy

  has_many :budget_allocations, :dependent => :restrict
  has_many :purchase_solicitations, :dependent => :restrict
  has_many :organogram_responsibles, :dependent => :destroy, :order => :id
  has_many :direct_purchases, :dependent => :restrict
  has_many :administrative_processes, :dependent => :restrict

  delegate :mask, :to => :organogram_configuration, :allow_nil => true

  validates :description, :organogram, :tce_code, :acronym, :presence => true
  validates :performance_field, :organogram_configuration, :presence => true
  validates :administration_type, :kind, :presence => true
  validates :organogram, :mask => :mask
  validate :cannot_have_duplicated_responsibles

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :organogram_responsibles, :allow_destroy => true

  orderize :description
  filterize

  def to_s
    "#{organogram} - #{description}"
  end

  protected

  def cannot_have_duplicated_responsibles
    single_responsibles = []

    organogram_responsibles.each do |organogram_responsible|
      if single_responsibles.include?(organogram_responsible.responsible_id)
        errors.add(:organogram_responsibles)
        organogram_responsible.errors.add(:responsible_id, :taken)
      end
      single_responsibles << organogram_responsible.responsible_id
    end
  end
end
