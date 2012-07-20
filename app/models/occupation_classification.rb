class OccupationClassification < Compras::Model
  attr_accessible :code, :name, :parent_id

  attr_modal :name

  acts_as_nested_set

  has_many :creditors, :dependent => :restrict

  validates :code, :presence => true, :uniqueness => true
  validates :name, :presence => true

  orderize :code
  filterize

  def to_s
    "#{code} - #{name}"
  end
end
