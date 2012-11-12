class Neighborhood < InscriptioCursualis::Neighborhood
  has_many :addresses, :dependent => :restrict

  scope :street_id, lambda { |street_id| joins(:streets).where { streets.id.eq(street_id) } }
  scope :city_id, lambda { |id| where { city_id.eq(id) } }

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
