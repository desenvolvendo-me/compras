class ReferenceUnit < Compras::Model
  attr_accessible :name, :acronym

  has_many :materials, :dependent => :restrict

  validates :name, :acronym, :presence => true, :uniqueness => { :allow_blank => true }
  validates_length_of :acronym, :maximum => 2, :allow_blank => true, :allow_nil => true

  filterize
  orderize

  def to_s
    acronym
  end
end
