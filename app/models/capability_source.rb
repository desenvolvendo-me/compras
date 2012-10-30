class CapabilitySource < Compras::Model
  attr_accessible :code, :name, :source, :specification

  has_enumeration_for :source

  has_many :checking_account_structure_informations

  validates :code, :name, :specification, :source, :presence => true
  validates :code, :uniqueness => true, :allow_blank => true

  orderize
  filterize

  def to_s
    name
  end
end
