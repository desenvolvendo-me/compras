class Subfunction < Compras::Model
  attr_accessible :descriptor_id, :code, :description, :function_id

  belongs_to :descriptor
  belongs_to :function

  has_many :budget_allocations, :dependent => :restrict

  orderize :code
  filterize

  def to_s
    "#{code} - #{description}"
  end
end
