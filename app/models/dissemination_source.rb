class DisseminationSource < ActiveRecord::Base
  attr_accessible :name, :communication_source_id

  belongs_to :communication_source

  validates :name, :communication_source, :presence => true

  filterize
  orderize

  def to_s
    name
  end
end
