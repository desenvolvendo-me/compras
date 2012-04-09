class Capability < ActiveRecord::Base
  attr_accessible :entity_id, :year, :description, :goal, :kind, :status

  has_enumeration_for :kind, :with => CapabilityKind
  has_enumeration_for :status, :create_helpers => true
  has_enumeration_for :source

  belongs_to :entity

  has_many :budget_allocations, :dependent => :restrict
  has_many :licitation_processes, :dependent => :restrict
  has_many :extra_credit_moviment_types, :dependent => :restrict

  validates :year, :mask => '9999'
  validates :entity_id, :year, :description, :goal, :kind, :status, :presence => true

  orderize :description
  filterize

  def to_s
    description
  end
end