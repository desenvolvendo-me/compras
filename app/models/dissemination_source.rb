class DisseminationSource < ActiveRecord::Base
  attr_accessible :name, :communication_source_id

  belongs_to :communication_source

  has_and_belongs_to_many :administractive_acts

  validates :name, :communication_source, :presence => true
  validates :name, :uniqueness => true

  filterize
  orderize

  def to_s
    name
  end
end
