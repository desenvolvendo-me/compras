class TypeOfAdministractiveAct < ActiveRecord::Base
  attr_accessible :name

  validates :name, :presence => true

  filterize
  orderize

  def to_s
    name
  end
end
