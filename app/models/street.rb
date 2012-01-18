class Street < ActiveRecord::Base
  attr_accessible :name, :street_type_id, :tax_zone, :neighborhood_ids

  attr_modal :name, :street_type_id

  attr_accessor :neighborhood

  has_and_belongs_to_many :neighborhoods
  accepts_nested_attributes_for :neighborhoods

  belongs_to :street_type
  has_many :addresses, :dependent => :restrict

  validates :name, :presence => true, :uniqueness => { :allow_blank => true }
  validates :street_type, :neighborhoods, :presence => true

  filterize
  orderize

  scope :neighborhood, lambda { |neighborhood| joins(:neighborhoods).where('neighborhoods.id = ?', neighborhood) }

  def to_s
    name.to_s
  end
end
