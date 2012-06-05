class Currency < ActiveRecord::Base
  attr_accessible :name, :acronym

  has_many :indexers, :dependent => :restrict

  validates :name, :acronym, :presence => true, :uniqueness => { :allow_blank => true }

  filterize
  orderize

  def to_s
    name
  end
end
