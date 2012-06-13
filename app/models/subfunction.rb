class Subfunction < Compras::Model
  attr_accessible :code, :description, :function_id, :entity_id, :year

  belongs_to :function
  belongs_to :entity

  has_many :budget_allocations, :dependent => :restrict

  validates :description, :entity, :year, :function, :code, :presence => true

  with_options :allow_blank => true do |allowing_blank|
    allowing_blank.validates :code, :numericality => true
    allowing_blank.validates :code, :description, :uniqueness => true
    allowing_blank.validates :year, :mask => '9999'
  end

  orderize :code
  filterize

  def to_s
    "#{code} - #{description}"
  end
end
