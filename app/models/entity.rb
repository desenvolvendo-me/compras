class Entity < ActiveRecord::Base
  attr_accessible :name

  orderize
  filterize

  validates :name, :presence => true
  validates :name, :uniqueness => true

  def to_s
    name
  end
end
