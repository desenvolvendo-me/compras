class MaterialsGroup < ActiveRecord::Base
  attr_accessible :group_number, :description

  attr_modal :group_number, :description

  has_many :materials_classes, :dependent => :restrict

  validates :description, :presence => true, :uniqueness => true
  validates :group_number, :presence => true, :uniqueness => true, :numericality => true, :mask => '99'

  orderize :description
  filterize

  def to_s
    "#{group_number} - #{description}"
  end
end
