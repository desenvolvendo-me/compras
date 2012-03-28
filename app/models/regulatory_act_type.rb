class RegulatoryActType < ActiveRecord::Base
  attr_accessible :description, :regulatory_act_type_classification_id

  belongs_to :regulatory_act_type_classification

  has_many :administractive_acts, :dependent => :restrict

  validates :description, :presence => true, :uniqueness => true
  validates :regulatory_act_type_classification, :presence => true

  filterize
  orderize :description

  def to_s
    description
  end
end
