class MaterialsGroup < ActiveRecord::Base
  attr_accessible :group, :name

  attr_modal :group, :name

  has_many :materials_classes

  orderize
  filterize

  validates :name, :presence => true, :uniqueness => true
  validates :group, :presence => true, :uniqueness => true, :numericality => true

  def to_s
    "#{group} - #{name}"
  end
end
