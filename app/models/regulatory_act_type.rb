class RegulatoryActType < Compras::Model
  include CustomData
  reload_custom_data

  attr_accessible :description, :imported

  has_many :regulatory_acts, :dependent => :restrict

  validates :description, :uniqueness => { :allow_blank => true }
  validates :description, :presence => true
  validate :validate_custom_data

  filterize
  orderize :description

  def to_s
    description
  end

  def updateable?
    !imported?
  end

  def destroyable?
    !imported?
  end
end
