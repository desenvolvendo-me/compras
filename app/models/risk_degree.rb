class RiskDegree < ActiveRecord::Base
  attr_accessible :name, :level

  has_many :cnaes, :dependent => :restrict

  validates :name, :level, :presence => true, :uniqueness => { :allow_blank => true }

  filterize
  orderize

  def to_s
    name
  end
end
