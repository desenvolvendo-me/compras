class GovernmentAction < Compras::Model
  attr_accessible :descriptor_id, :description, :status

  has_enumeration_for :status, :create_helpers => true

  belongs_to :descriptor

  has_many :budget_allocations, :dependent => :restrict

  orderize :description
  filterize

  def to_s
    description
  end
end
