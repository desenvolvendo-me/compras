class Neighborhood < Unico::Neighborhood
  attr_accessible :name, :city_id, :district_id

  has_many :addresses, :dependent => :restrict

  scope :street_id, lambda { |street_id| joins(:streets).where { streets.id.eq(street_id) } }

  before_destroy :validate_street_relationship

  filterize
  orderize

  protected

  def validate_street_relationship
    return unless streets.any?

    errors.add(:base, :cant_be_destroyed)

    false
  end
end
