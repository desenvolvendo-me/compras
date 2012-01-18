class StreetType < ActiveRecord::Base
  attr_accessible :name, :acronym

  has_many :streets, :dependent => :restrict

  validates :name, :presence => true, :uniqueness => { :allow_blank => true}
  validates_length_of :acronym, :is => 3
  validates :acronym, :mask => 'aaa'

  filterize
  orderize

  def to_s
    name
  end
end
