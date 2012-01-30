class MaterialsGroup < ActiveRecord::Base
  attr_accessible :group, :name

  attr_modal :group, :name

  has_many :materials_classes

  orderize
  filterize

  validates :group, :name, :presence => true, :uniqueness => true

  def to_s
    "#{group} - #{name}"
  end
end
