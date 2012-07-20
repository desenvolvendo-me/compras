class LegalTextNature < Compras::Model
  attr_accessible :description

  attr_modal :description

  has_many :regulatory_acts, :dependent => :restrict

  validates :description, :presence => true, :uniqueness => { :allow_blank => true }

  orderize :description
  filterize

  def to_s
    description
  end
end
