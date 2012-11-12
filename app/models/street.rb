class Street < InscriptioCursualis::Street
  attr_accessor :neighborhood

  attr_modal :name, :street_type_id

  has_many :addresses, :dependent => :restrict

  accepts_nested_attributes_for :neighborhoods

  filterize
  orderize

  scope :neighborhood, lambda { |neighborhood| joins(:neighborhoods).where('neighborhoods.id = ?', neighborhood) }
end
