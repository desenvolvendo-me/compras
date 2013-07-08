class DisseminationSource < Compras::Model
  attr_accessible :description, :communication_source_id

  belongs_to :communication_source

  validates :description, :communication_source, :presence => true
  validates :description, :uniqueness => { :allow_blank => true }

  filterize
  orderize :description

  def to_s
    description
  end

  def destroyable?
    regulatory_acts.empty?
  end
end
