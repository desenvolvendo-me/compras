class LandSubdivision < ActiveRecord::Base
  attr_accessible :name

  has_many :addresses, :dependent => :restrict

  validates :name, :presence => true

  filterize
  orderize

  def to_s
    name
  end
end
