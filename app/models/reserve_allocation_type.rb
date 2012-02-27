class ReserveAllocationType < ActiveRecord::Base
  attr_accessible :description, :status

  has_enumeration_for :status

  has_many :reserve_funds, :dependent => :restrict

  validates :description, :status, :presence => true
  validates :description, :uniqueness => true

  orderize :description
  filterize

  def to_s
    description
  end
end
