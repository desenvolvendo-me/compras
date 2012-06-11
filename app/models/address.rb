class Address < ActiveRecord::Base
  attr_accessible :street_id, :neighborhood_id, :land_subdivision_id, :complement
  attr_accessible :condominium_id, :addressable_id, :addressable_type
  attr_accessible :addressable, :zip_code, :block, :number, :correspondence, :room

  belongs_to :neighborhood
  belongs_to :street
  belongs_to :land_subdivision
  belongs_to :condominium
  belongs_to :addressable, :polymorphic => true

  delegate :street_type, :to => :street, :allow_nil => true
  delegate :city, :district, :to => :neighborhood, :allow_nil => true
  delegate :state, :to => :city, :allow_nil => true
  delegate :country, :to => :state, :allow_nil => true

  validates :neighborhood, :street, :zip_code, :presence => true
  validates :zip_code, :mask => "99999-999", :allow_blank => true
  validates :number, :numericality => { :allow_blank => true }

  def to_s
    "#{street}, #{number} - #{neighborhood}"
  end
end
