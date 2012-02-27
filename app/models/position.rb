class Position < ActiveRecord::Base
  attr_accessible :name

  has_many :employees, :dependent => :restrict

  validates :name, :uniqueness => true, :presence => true

  orderize
  filterize

  def to_s
    name
  end
end
