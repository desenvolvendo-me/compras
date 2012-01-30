class TypeOfAdministractiveAct < ActiveRecord::Base
  attr_accessible :name

  validates :name, :presence => true
  validates :name, :uniqueness => true

  filterize
  orderize

  def to_s
    name
  end
end
