class DisseminationSource < ActiveRecord::Base
  attr_accessible :description, :communication_source_id

  attr_modal :communication_source

  belongs_to :communication_source

  validates :description, :communication_source, :presence => true

  filterize
  orderize :description

  def to_s
    description
  end
end
