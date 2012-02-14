class ClassificationOfTypesOfAdministractiveAct < ActiveRecord::Base
  attr_accessible :description

  validates :description, :presence => true

  orderize :description
  filterize

  def to_s
    description
  end
end
