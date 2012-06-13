class RegulatoryActTypeClassification < Compras::Model
  attr_accessible :description

  has_many :regulatory_act_types, :dependent => :restrict

  validates :description, :uniqueness => { :allow_blank => true }, :presence => true

  orderize :description
  filterize

  def to_s
    description
  end
end
