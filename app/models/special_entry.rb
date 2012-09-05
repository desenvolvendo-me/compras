class SpecialEntry < Compras::Model
  attr_accessible :name

  has_many :creditors, :as => :creditable, :dependent => :restrict

  validates :name, :presence => true
  validates :name, :uniqueness => true, :allow_blank => true

  orderize
  filterize

  def to_s
    name
  end
end
