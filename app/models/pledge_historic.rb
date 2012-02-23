class PledgeHistoric < ActiveRecord::Base
  attr_accessible :description, :entity_id, :year

  orderize :description
  filterize

  belongs_to :entity
  has_many :pledges, :dependent => :restrict

  validates :description, :entity, :year, :presence => true
  validates :year, :mask => "9999"

  def to_s
    description
  end
end
