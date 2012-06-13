class MovimentType < Compras::Model
  attr_accessible :name, :operation, :character

  has_enumeration_for :operation, :with => MovimentTypeOperation, :create_helpers => true
  has_enumeration_for :character, :with => MovimentTypeCharacter, :create_helpers => true

  has_many :extra_credit_moviment_types, :dependent => :restrict

  validates :name, :operation, :character, :presence => true

  filterize
  orderize

  def to_s
    name
  end
end
