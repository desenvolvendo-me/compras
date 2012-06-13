class CommunicationSource < Compras::Model
  attr_accessible :description

  has_many :dissemination_sources, :dependent => :restrict

  validates :description, :presence => true, :uniqueness => { :allow_blank => true }

  filterize
  orderize :description

  def to_s
    description
  end
end
