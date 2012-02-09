class MaterialsGroup < ActiveRecord::Base
  attr_accessible :group_number, :description

  attr_modal :group_number, :description

  has_many :materials_classes

  orderize :description
  filterize

  validates :description, :presence => true, :uniqueness => true
  validates :group_number, :presence => true, :uniqueness => true, :numericality => true

  def to_s
    "#{group_number} - #{description}"
  end
end
