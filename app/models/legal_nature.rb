class LegalNature < ActiveRecord::Base
  attr_accessible :code, :name, :parent_id

  acts_as_nested_set

  has_many :administration_types

  validates :name, :code, :presence => true

  filterize
  orderize :created_at

  def to_s
    name
  end
end
