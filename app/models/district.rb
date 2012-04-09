class District < ActiveRecord::Base
  attr_accessible :name, :city_id

  belongs_to :city

  validates :name, :city, :presence => true
  validates :name, :uniqueness => true, :allow_blank => { :allow_blank => true }

  orderize
  filterize

  def to_s
    name
  end
end
