class Street < ActiveRecord::Base
  attr_accessible :name, :street_type_id, :tax_zone, :neighborhood_ids

  attr_accessor :neighborhood

  attr_modal :name, :street_type_id

  belongs_to :street_type

  has_and_belongs_to_many :neighborhoods

  has_many :addresses, :dependent => :restrict

  accepts_nested_attributes_for :neighborhoods

  validates :name, :presence => true, :uniqueness => { :allow_blank => true }
  validates :street_type, :neighborhoods, :presence => true

  filterize
  orderize

  scope :neighborhood, lambda { |neighborhood| joins(:neighborhoods).where('neighborhoods.id = ?', neighborhood) }

  def to_s
    name.to_s
  end
end
