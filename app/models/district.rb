class District < ActiveRecord::Base
  attr_accessible :name, :city_id

  belongs_to :city
  has_many :addresses, :dependent => :restrict

  validates :name, :city, :presence => true
  validates :name, :uniqueness => true, :allow_blank => true

  filterize
  orderize

  def to_s
    name
  end
end
