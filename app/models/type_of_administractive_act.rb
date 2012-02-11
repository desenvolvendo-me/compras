class TypeOfAdministractiveAct < ActiveRecord::Base
  attr_accessible :description

  has_many :administractive_acts, :dependent => :restrict

  validates :description, :presence => true, :uniqueness => true

  filterize
  orderize :description

  def to_s
    description
  end
end
