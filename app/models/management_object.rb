class ManagementObject < Compras::Model
  attr_accessible :description, :status, :object

  attr_modal :description, :status
  has_enumeration_for :status, with: ObjectStatus

  validates :description, :status, presence: true

  orderize :id
  filterize
end
