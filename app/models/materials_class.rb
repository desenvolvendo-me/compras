class MaterialsClass < Compras::Model
  attr_accessible :materials_group_id, :class_number, :description, :details

  belongs_to :materials_group

  has_many :materials, :dependent => :restrict

  validates :materials_group, :description, :class_number, :presence => true
  validates :class_number, :description, :uniqueness => { :scope => :materials_group_id, :allow_blank => true }
  validates :class_number, :numericality => true, :mask => "99", :allow_blank => true

  orderize :description
  filterize

  def to_s
    "#{class_number} - #{description}"
  end
end
