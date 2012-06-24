class GovernmentProgram < Compras::Model
  attr_accessible :descriptor_id, :description, :status

  has_enumeration_for :status

  belongs_to :descriptor

  has_many :budget_allocations, :dependent => :restrict

  validates :descriptor, :description, :status, :presence => true

  orderize :description
  filterize

  def to_s
    description
  end
end
