class Neighborhood < Unico::Neighborhood
  attr_accessible :name, :city_id, :district_id

  belongs_to :city
  belongs_to :district

  has_many :addresses, :dependent => :restrict

  delegate :state, :to => :city, :allow_nil => true

  validates :city, :name, :presence => true
  validates :name, :uniqueness => { :scope => [:city_id, :district_id] }, :allow_blank => true
  validate :district_city

  scope :street_id, lambda { |street_id| joins(:streets).where { streets.id.eq(street_id) } }

  before_destroy :validate_street_relationship

  filterize
  orderize

  def to_s
    name.to_s
  end

  protected

  def district_city
    return unless district

    if city.districts.exclude?(district)
      errors.add(:district, :invalid)
    end
  end

  def validate_street_relationship
    return unless streets.any?

    errors.add(:base, :cant_be_destroyed)

    false
  end
end
