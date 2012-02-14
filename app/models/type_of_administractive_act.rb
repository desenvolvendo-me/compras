class TypeOfAdministractiveAct < ActiveRecord::Base
  attr_accessible :description, :classification_of_types_of_administractive_act_id

  belongs_to :classification_of_types_of_administractive_act

  has_many :administractive_acts, :dependent => :restrict

  validates :description, :presence => true, :uniqueness => true

  filterize
  orderize :description

  def to_s
    description
  end
end
