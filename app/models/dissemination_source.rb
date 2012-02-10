class DisseminationSource < ActiveRecord::Base
  attr_accessible :description, :communication_source_id

  belongs_to :communication_source

  has_and_belongs_to_many :administractive_acts

  validates :description, :communication_source, :presence => true
  validates :description, :uniqueness => true

  filterize
  orderize :description

  def to_s
    description
  end
end
