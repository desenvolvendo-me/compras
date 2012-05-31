class Neighborhood < ActiveRecord::Base
  attr_accessible :name, :city_id

  belongs_to :city

  has_many :addresses, :dependent => :restrict

  has_and_belongs_to_many :streets

  delegate :state, :to => :city, :allow_nil => true

  validates :name, :uniqueness => { :scope => :city_id, :allow_blank => true }
  validates :city, :name, :presence => true

  before_destroy :validate_street_relationship

  orderize
  filterize

  scope :street_id, lambda { |street_id|
    joins(:streets).where { streets.id.eq(street_id) }
  }

  def to_s
    name.to_s
  end

  protected

  def validate_street_relationship
    return unless streets.any?

    errors.add(:base, :cant_be_destroyed)

    false
  end
end
