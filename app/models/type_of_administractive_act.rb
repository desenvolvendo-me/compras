class TypeOfAdministractiveAct < ActiveRecord::Base
  attr_accessible :description

  validates :description, :presence => true, :uniqueness => true

  filterize
  orderize :description

  def to_s
    description
  end
end
