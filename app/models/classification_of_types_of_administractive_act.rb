class ClassificationOfTypesOfAdministractiveAct < ActiveRecord::Base
  attr_accessible :description

  has_many :type_of_administractive_acts, :dependent => :restrict

  validates :description, :uniqueness => true, :presence => true

  orderize :description
  filterize

  def to_s
    description
  end
end
