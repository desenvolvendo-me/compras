class ManagementObject < Compras::Model
  attr_accessible :description, :status, :object


  validates :description, :status, presence: true

  orderize :id
  filterize
end
