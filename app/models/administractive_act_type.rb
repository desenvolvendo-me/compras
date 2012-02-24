class AdministractiveActType < ActiveRecord::Base
  attr_accessible :description, :administractive_act_type_classification_id

  belongs_to :administractive_act_type_classification

  has_many :administractive_acts, :dependent => :restrict

  validates :description, :presence => true, :uniqueness => true
  validates :administractive_act_type_classification, :presence => true

  filterize
  orderize :description

  def to_s
    description
  end
end
