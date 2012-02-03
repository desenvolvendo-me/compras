class MaterialsClass < ActiveRecord::Base
  attr_accessible :materials_group_id, :class_number, :name, :description

  belongs_to :materials_group

  validates :materials_group_id, :class_number, :name, :presence => true
  validates :class_number, :name, :uniqueness => true
  validates :class_number, :numericality => true

  orderize
  filterize

  def to_s
    "#{class_number} - #{name}"
  end
end
