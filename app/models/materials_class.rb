class MaterialsClass < ActiveRecord::Base
  attr_accessible :materials_group_id, :class_number, :name, :description

  belongs_to :materials_group

  validates :materials_group_id, :presence => true
  validates :name, :presence => true, :uniqueness => true
  validates :class_number, :presence => true, :uniqueness => true, :numericality => true

  orderize
  filterize

  def to_s
    "#{class_number} - #{name}"
  end
end
