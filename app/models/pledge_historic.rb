class PledgeHistoric < ActiveRecord::Base
  attr_accessible :description, :entity_id

  orderize :description
  filterize

  belongs_to :entity

  validates :description, :entity_id, :presence => true

  def to_s
    description
  end
end
