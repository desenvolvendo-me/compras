class SpecialEntry < Compras::Model
  attr_accessible :name

  has_many :creditors, :as => :creditable, :dependent => :restrict

  validates :name, :presence => true, :uniqueness => true

  orderize
  filterize

  def to_s
    name
  end
end
