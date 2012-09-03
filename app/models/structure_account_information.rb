class StructureAccountInformation < Compras::Model
  attr_accessible :name, :tce_code, :capability_source_id

  belongs_to :capability_source

  validates :name, :tce_code, :presence => true

  orderize
  filterize

  def to_s
    name
  end
end
