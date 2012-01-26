class TypeOfAdministractiveAct < ActiveRecord::Base

  validates :description, :presence => true

  filterize
  orderize :description

  def to_s
    description
  end
end
