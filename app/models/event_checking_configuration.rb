class EventCheckingConfiguration < Compras::Model
  attr_accessible :event, :function, :descriptor_id

  belongs_to :descriptor

  validates :event, :function, :descriptor, :presence => true

  orderize :id
  filterize

  def to_s
    event
  end
end
