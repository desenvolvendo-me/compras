class AdministractiveActTypeClassification < ActiveRecord::Base
  attr_accessible :description

  has_many :administractive_act_types, :dependent => :restrict

  validates :description, :uniqueness => true, :presence => true

  orderize :description
  filterize

  def to_s
    description
  end
end
