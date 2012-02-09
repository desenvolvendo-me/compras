class MaterialsClass < ActiveRecord::Base
  attr_accessible :materials_group_id, :class_number, :description, :details

  attr_modal :materials_group_id, :class_number, :description

  belongs_to :materials_group

  validates :materials_group_id, :presence => true
  validates :description, :presence => true, :uniqueness => { :scope => :materials_group_id }
  validates :class_number, :presence => true, :uniqueness => { :scope => :materials_group_id }, :numericality => true

  orderize :description
  filterize

  def to_s
    "#{class_number} - #{description}"
  end
end
