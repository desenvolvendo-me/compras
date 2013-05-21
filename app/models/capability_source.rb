class CapabilitySource < Accounting::Model
  attr_accessible :code, :name, :source, :specification

  has_enumeration_for :source

  has_many :tce_specification_capabilities
  has_many :checking_account_structure_informations

  orderize
  filterize

  def to_s
    "#{ code } - #{ name }"
  end
end
