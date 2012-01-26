class MaterialsClass < ActiveRecord::Base
  attr_accessible :materials_group_id, :name, :description

  belongs_to :materials_group

  validates :materials_group_id, :name, :presence => true
  validates :name, :uniqueness => true

  orderize
  filterize

  def to_s
    name
  end
end
