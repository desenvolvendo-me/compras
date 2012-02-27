class Position < ActiveRecord::Base
  attr_accessible :name

  validates :name, :uniqueness => true, :presence => true

  orderize
  filterize

  def to_s
    name
  end
end
