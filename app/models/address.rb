class Address < ActiveRecord::Base
  attr_accessible :street_id, :neighborhood_id, :district_id, :land_subdivision_id
  attr_accessible :condominium_id, :addressable_id, :addressable_type, :complement
  attr_accessible :addressable, :zip_code, :block, :number, :correspondence, :room

  belongs_to :neighborhood
  belongs_to :street
  belongs_to :district
  belongs_to :land_subdivision
  belongs_to :condominium
  belongs_to :addressable, :polymorphic => true

  delegate :street_type, :to => 'street', :allow_nil => true
  delegate :city, :to => 'neighborhood', :allow_nil => true
  delegate :state, :to => 'city', :allow_nil => true
  delegate :country, :to => 'state', :allow_nil => true

  validates :neighborhood, :street, :zip_code, :presence => true
  validates :zip_code, :mask => "99999-999"
  validates :number, :numericality => true, :allow_blank => true

  def to_s
    "#{street}, #{number} - #{neighborhood}"
  end
end
