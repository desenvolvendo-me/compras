class MaterialsClass < Compras::Model
  attr_accessible :class_number, :description, :details, :mask

  attr_modal :class_number, :description

  has_many :materials, :dependent => :restrict

  validates :description, :class_number, :mask, :presence => true
  validates :class_number, :uniqueness => { :scope => :description, :allow_blank => true }

  orderize :description
  filterize

  def to_s
    "#{class_number} - #{description}"
  end
end
