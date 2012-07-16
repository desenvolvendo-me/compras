class MovimentType < Compras::Model
  attr_accessible :name, :operation, :character, :source

  has_enumeration_for :operation, :with => MovimentTypeOperation, :create_helpers => true
  has_enumeration_for :character, :with => MovimentTypeCharacter, :create_helpers => true
  has_enumeration_for :source

  has_many :extra_credit_moviment_types, :dependent => :restrict

  validates :name, :operation, :character, :source, :presence => true

  filterize
  orderize

  def to_s
    name
  end

  def self.sum_operation
    MovimentTypeOperation::SUM
  end

  def self.subtraction_operation
    MovimentTypeOperation::SUBTRACTION
  end

  def self.budget_allocation_character
    MovimentTypeCharacter::BUDGET_ALLOCATION
  end

  def self.capability_character
    MovimentTypeCharacter::CAPABILITY
  end

  def self.default_source
    Source::DEFAULT
  end
end
