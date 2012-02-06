class MaterialsGroup < ActiveRecord::Base
  attr_accessible :group_number, :name

  attr_modal :group_number, :name

  has_many :materials_classes

  orderize
  filterize

  validates :name, :presence => true, :uniqueness => true
  validates :group_number, :presence => true, :uniqueness => true, :numericality => true

  def to_s
    "#{group_number} - #{name}"
  end
end
