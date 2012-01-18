class CondominiumType < ActiveRecord::Base
  attr_accessible :name

  has_many :condominiums, :dependent => :restrict

  validates :name, :presence => true, :uniqueness => { :allow_blank => true }

  filterize
  orderize

  def to_s
    name.to_s
  end
end
