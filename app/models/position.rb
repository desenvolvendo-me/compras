class Position < Compras::Model
  attr_accessible :name

  has_many :employees, :dependent => :restrict

  validates :name, :presence => true, :uniqueness => { :allow_blank => true }

  orderize
  filterize

  def to_s
    name
  end
end
