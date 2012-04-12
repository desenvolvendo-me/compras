class Condominium < ActiveRecord::Base
  attr_accessible :name, :condominium_type

  has_enumeration_for :condominium_type

  validates :name, :condominium_type, :presence => true

  filterize
  orderize

  def to_s
    name.to_s
  end
end
