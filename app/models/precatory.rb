class Precatory < ActiveRecord::Base
  attr_accessible :number, :provider_id, :historic, :precatory_type_id
  attr_accessible :date, :judgment_date, :apresentation_date, :lawsuit_number

  belongs_to :provider
  belongs_to :precatory_type

  validates :number, :provider, :historic, :precatory_type, :presence => true
  validates :date, :judgment_date, :apresentation_date, :presence=> true

  orderize :id
  filterize

  def to_s
    id.to_s
  end
end
