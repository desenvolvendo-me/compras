# frozen_string_literal: true

class Street < InscriptioCursualis::Street
  attr_accessible :zip_code
  attr_accessor :neighborhood

  attr_modal :name, :street_type_id

  has_many :addresses, dependent: :restrict

  # validates :zip_code, mask: '99999-999', allow_blank: true

  accepts_nested_attributes_for :neighborhoods

  filterize
  orderize

  scope :neighborhood, lambda { |neighborhood| joins(:neighborhoods).where('neighborhoods.id = ?', neighborhood) }
  scope :by_zip_code, lambda { |param| where {zip_code.like("%#{param}%")} }

  scope :term, lambda {|q|
    where {name.like("%#{q}%")}
  }
end
