class DisseminationSource < ActiveRecord::Base
  attr_accessible :name, :communication_source_id

  belongs_to :communication_source

  has_and_belongs_to_many :administractive_acts

  acts_as_nested_set

  validates :name, :communication_source, :presence => true

  filterize
  orderize

  def to_s
    name
  end
end
