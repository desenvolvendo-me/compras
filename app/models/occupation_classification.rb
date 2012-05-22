class OccupationClassification < ActiveRecord::Base
  attr_accessible :code, :name, :parent_id

  acts_as_nested_set

  validates :code, :presence => true, :uniqueness => true
  validates :name, :presence => true

  orderize :code
  filterize

  def to_s
    "#{code} - #{name}"
  end
end
