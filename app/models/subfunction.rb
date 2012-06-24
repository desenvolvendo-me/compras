class Subfunction < Compras::Model
  attr_accessible :descriptor_id, :code, :description, :function_id

  belongs_to :descriptor
  belongs_to :function

  has_many :budget_allocations, :dependent => :restrict

  validates :descriptor, :description, :function, :code, :presence => true

  with_options :allow_blank => true do |allowing_blank|
    allowing_blank.validates :code, :numericality => true
    allowing_blank.validates :code, :description, :uniqueness => true
  end

  orderize :code
  filterize

  def to_s
    "#{code} - #{description}"
  end
end
