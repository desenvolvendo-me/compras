class Neighborhood < ActiveRecord::Base
  attr_accessible :name, :city_id

  has_and_belongs_to_many :streets
  belongs_to :city
  has_many :addresses, :dependent => :restrict

  validates :name, :presence => true, :uniqueness => { :scope => [:city_id] }
  validates :city, :presence => true

  delegate :state, :to => :city, :allow_nil => true

  scope :street_id, lambda { |street_id| joins(:streets).where { streets.id.eq(street_id) } }

  filterize
  orderize

  def to_s
    name.to_s
  end
end
