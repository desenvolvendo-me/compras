class Condominium < ActiveRecord::Base
  attr_accessible :name, :condominium_type_id, :built_area, :area_common_user
  attr_accessible :construction_year, :quantity_garages, :quantity_units, :quantity_blocks
  attr_accessible :quantity_elevators, :quantity_rooms, :quantity_floors, :address_attributes

  attr_modal :name, :condominium_type_id, :built_area, :area_common_user
  attr_modal :construction_year, :quantity_garages, :quantity_units, :quantity_blocks
  attr_modal :quantity_elevators, :quantity_rooms, :quantity_floors

  belongs_to :condominium_type
  has_one :address, :as => :addressable, :dependent => :destroy

  accepts_nested_attributes_for :address

  validates :name, :built_area, :area_common_user, :construction_year, :condominium_type, :presence => true
  validates :construction_year, :numericality => true

  filterize
  orderize

  def to_s
    name.to_s
  end
end
