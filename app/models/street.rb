class Street < Unico::Street
  attr_accessor :neighborhood

  has_many :addresses, :dependent => :restrict

  accepts_nested_attributes_for :neighborhoods

  filterize
  orderize

  scope :neighborhood, lambda { |neighborhood| joins(:neighborhoods).where('neighborhoods.id = ?', neighborhood) }
end
