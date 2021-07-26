class ManagementUnit < Compras::Model
  attr_accessible :descriptor_id, :description, :acronym, :status

  has_enumeration_for :status, :create_helpers => true

  validates :descriptor_id, :description, :acronym, :status, :presence => true

  orderize :description
  filterize

  def descriptor
    @descriptor ||= Descriptor.find(descriptor_id) if descriptor_id
  end

  def to_s
    description
  end
end
