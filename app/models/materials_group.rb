class MaterialsGroup < ActiveRecord::Base
  orderize
  filterize

  validates :group, :name, :presence => true, :uniqueness => true

  def to_s
    group
  end
end
