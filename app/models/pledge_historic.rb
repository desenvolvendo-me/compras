class PledgeHistoric < ActiveRecord::Base
  attr_accessible :description, :entity_id, :year

  orderize :description
  filterize

  belongs_to :entity

  validates :description, :entity, :year, :presence => true
  validates :year, :mask => "9999"

  def to_s
    description
  end
end
